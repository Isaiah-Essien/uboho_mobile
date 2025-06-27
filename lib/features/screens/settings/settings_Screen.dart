import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:uboho/features/screens/settings/personal_info.dart';
import 'package:uboho/utiils/constants/colors.dart';

import '../../../service_backend/settiings_logics/profile_picture_service.dart';
import '../../../utiils/popups/logout_confirmation.dart';
import '../onboarding/onboarding_screen.dart';
import 'about_uboho.dart';
import 'medical_info.dart';
import 'emergency_contact.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isNotificationOn = true;
  final ImagePicker _picker = ImagePicker();
  final ProfileImageService _imageService = ProfileImageService();

  XFile? _selectedImage;
  String patientName = '';
  String? profileImageUrl;

  @override
  void initState() {
    super.initState();
    _fetchPatientName();
    _loadProfileImage();
  }

  Future<void> _fetchPatientName() async {
    final authUid = FirebaseAuth.instance.currentUser?.uid;
    if (authUid == null) return;

    final hospitalsSnapshot =
    await FirebaseFirestore.instance.collection('hospitals').get();

    for (final hospitalDoc in hospitalsSnapshot.docs) {
      final patientsRef = hospitalDoc.reference.collection('patients');

      final matchQuery = await patientsRef
          .where('authId', isEqualTo: authUid)
          .limit(1)
          .get();

      if (matchQuery.docs.isNotEmpty) {
        final doc = matchQuery.docs.first;
        setState(() {
          patientName = doc['name'] ?? '';
        });
        break;
      }
    }
  }

  Future<void> _loadProfileImage() async {
    final url = await _imageService.fetchProfileImageUrl();
    if (url != null) {
      setState(() {
        profileImageUrl = url;
      });
    }
  }

  Future<void> _pickImage() async {
    XFile? uploadedImage;

    uploadedImage = await _imageService.pickAndUploadImage(
      context: context,
      onUploadComplete: (url) {
        setState(() {
          profileImageUrl = url;
          _selectedImage = uploadedImage;
        });
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UColors.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 24),
          child: Column(
            children: [
              const SizedBox(height: 20),

              // Profile Picture with camera icon
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.white24,
                    backgroundImage: _selectedImage != null
                        ? FileImage(File(_selectedImage!.path))
                        : (profileImageUrl != null
                        ? CachedNetworkImageProvider(profileImageUrl!)
                        : null),
                  ),

                  GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: UColors.boxHighlightColor,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        LucideIcons.camera,
                        color: UColors.primaryColor,
                        size: 16,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              Text(
                patientName.isEmpty ? "Loading..." : patientName,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 24),

              _buildSettingsGroup([
                _buildSettingsTile("Personal information",
                    onTap: () => Get.to(() => const PersonalInformationScreen())),
                _buildSettingsTile("Medical information",
                    onTap: () => Get.to(() => const MedicalInformationScreen())),
                _buildSettingsTile("Emergency contact",
                    onTap: () => Get.to(EmergencyContactScreen())),
                _buildSwitchTile("Notifications", isNotificationOn, (val) {
                  setState(() => isNotificationOn = val);
                }),
              ]),

              const SizedBox(height: 16),

              _buildSettingsGroup([
                _buildSettingsTile("About Uboho",
                    onTap: () => Get.to(AboutUbohoScreen())),
                _buildSettingsTile("Privacy Policy"),
                _buildSettingsTile("Terms & Conditions"),
                _buildSettingsTile(
                  "App version",
                  trailing: const Text("v1.0", style: TextStyle(color: Colors.white)),
                ),
              ]),

              const SizedBox(height: 24),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      showLogoutConfirmationPopup(context);
                    },
                    icon: const Icon(LucideIcons.logOut, color: Colors.white),
                    label: const Text("Logout", style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: UColors.boxHighlightColor,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsGroup(List<Widget> tiles) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        decoration: BoxDecoration(
          color: UColors.boxHighlightColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: List.generate(
            tiles.length * 2 - 1,
                (index) => index.isEven
                ? tiles[index ~/ 2]
                : Divider(
              height: 1,
              thickness: 0.5,
              color: UColors.dividerColor.withOpacity(0.4),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsTile(String title, {Widget? trailing, VoidCallback? onTap}) {
    return ListTile(
      onTap: onTap ?? () {},
      title: Text(title, style: const TextStyle(color: Colors.white)),
      trailing: trailing ?? const Icon(Icons.chevron_right, color: Colors.white70),
    );
  }

  Widget _buildSwitchTile(String title, bool value, Function(bool) onChanged) {
    return SwitchListTile(
      title: Text(title, style: const TextStyle(color: Colors.white)),
      value: value,
      onChanged: onChanged,
      activeColor: Colors.white,
      activeTrackColor: UColors.primaryColor,
      inactiveTrackColor: Colors.white24,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
    );
  }
}
