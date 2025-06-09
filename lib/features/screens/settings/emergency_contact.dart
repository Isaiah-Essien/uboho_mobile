import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:uboho/utiils/constants/colors.dart';
import 'package:uboho/features/reuseable_widgets/primary_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import 'add_emergency_contact.dart';

class EmergencyContactScreen extends StatefulWidget {
  const EmergencyContactScreen({super.key});

  @override
  State<EmergencyContactScreen> createState() => _EmergencyContactScreenState();
}

class _EmergencyContactScreenState extends State<EmergencyContactScreen> {
  Map<String, dynamic>? emergencyContact;
  DocumentReference? patientRef;

  @override
  void initState() {
    super.initState();
    _loadEmergencyContact();
  }

  Future<void> _loadEmergencyContact() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final hospitals = await FirebaseFirestore.instance.collection('hospitals').get();

    for (final hospital in hospitals.docs) {
      final patients = hospital.reference.collection('patients');
      final query = await patients.where('authId', isEqualTo: uid).limit(1).get();

      if (query.docs.isNotEmpty) {
        final doc = query.docs.first;
        patientRef = doc.reference;
        setState(() {
          emergencyContact = doc['emergencyContact'] as Map<String, dynamic>?;
        });
        break;
      }
    }
  }

  Future<void> _deleteEmergencyContact() async {
    if (patientRef != null) {
      await patientRef!.update({'emergencyContact': FieldValue.delete()});
      setState(() {
        emergencyContact = null;
      });
    }
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri uri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      Get.snackbar('Error', 'Could not launch dialer');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UColors.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Row(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      color: UColors.boxHighlightColor,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.chevron_left, color: Colors.white),
                      onPressed: () => Get.back(),
                    ),
                  ),
                  const Expanded(
                    child: Text(
                      'Emergency Contact',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      color: UColors.boxHighlightColor,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.add, color: Colors.white),
                      onPressed: () => Get.to(AddEmergencyContactScreen()),
                    ),
                  ),
                ],
              ),
            ),

            // Emergency Contact Card
            if (emergencyContact != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  decoration: BoxDecoration(
                    color: UColors.boxHighlightColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      // Header Row with name and delete icon
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                        child: Row(
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: UColors.backgroundColor,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Icon(Icons.person, size: 20, color: Colors.white),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                emergencyContact!['name'] ?? '',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(LucideIcons.trash2, color: Colors.redAccent),
                              onPressed: _deleteEmergencyContact,
                            ),
                          ],
                        ),
                      ),

                      const _DividerLine(),

                      _InfoRow(label: "Relation", value: emergencyContact!['relation'] ?? ''),
                      const _DividerLine(),
                      _InfoRow(
                          label: "Phone",
                          value:
                          "${emergencyContact!['countryCode'] ?? ''} ${emergencyContact!['phone'] ?? ''}"),
                      const _DividerLine(),
                      _InfoRow(label: "Email", value: emergencyContact!['email'] ?? ''),

                      const SizedBox(height: 20),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: PrimaryButton(
                          text: "Call ${emergencyContact!['name'] ?? 'Contact'}",
                          onPressed: () {
                            final raw = emergencyContact!['phone'] ?? '';
                            final code = emergencyContact!['countryCode'] ?? '';
                            _makePhoneCall("$code$raw");
                          },
                        ),
                      ),

                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w400)),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w400),
            ),
          ),
        ],
      ),
    );
  }
}

class _DividerLine extends StatelessWidget {
  const _DividerLine();

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1,
      thickness: 0.5,
      color: UColors.dividerColor.withOpacity(0.5),
    );
  }
}
