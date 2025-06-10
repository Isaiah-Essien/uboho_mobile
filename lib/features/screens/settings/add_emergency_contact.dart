import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uboho/features/reuseable_widgets/custom_input.dart';
import 'package:uboho/features/reuseable_widgets/onboarding_title_subtitle.dart';
import 'package:uboho/features/reuseable_widgets/primary_button.dart';
import 'package:uboho/utiils/constants/colors.dart';

import '../../reuseable_widgets/country_code_picker.dart';

class AddEmergencyContactScreen extends StatefulWidget {
  const AddEmergencyContactScreen({super.key});

  @override
  State<AddEmergencyContactScreen> createState() =>
      _AddEmergencyContactScreenState();
}

class _AddEmergencyContactScreenState
    extends State<AddEmergencyContactScreen> {
  final nameKey = GlobalKey<CustomInputFieldState>();
  final relationKey = GlobalKey<CustomInputFieldState>();
  final emailKey = GlobalKey<CustomInputFieldState>();
  final phoneKey = GlobalKey<CustomInputFieldState>();
  final primaryKey = GlobalKey<CustomInputFieldState>();

  final TextEditingController nameController =
  TextEditingController();
  final TextEditingController relationController =
  TextEditingController();
  final TextEditingController emailController =
  TextEditingController();
  final TextEditingController phoneController =
  TextEditingController();

  String? selectedPrimary;
  String selectedCountryCode = '+250';
  String selectedFlag = 'rwanda_flag.webp';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UColors.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding:
          const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back icon
              Container(
                decoration: const BoxDecoration(
                  color: UColors.boxHighlightColor,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(Icons.chevron_left,
                      color: Colors.white),
                  onPressed: () => Get.back(),
                ),
              ),

              const SizedBox(height: 20),

              const OnboardingTitleSubtitle(
                title: "New Contact",
                subtitle:
                "Set up a new emergency contact! We will reach out to them in case you need help",
              ),

              const SizedBox(height: 32),

              CustomInputField(
                key: nameKey,
                hintText: "Full Names",
                controller: nameController,
              ),
              const SizedBox(height: 16),

              CustomInputField(
                key: relationKey,
                hintText: "Relation",
                controller: relationController,
              ),
              const SizedBox(height: 16),

              CustomInputField(
                key: emailKey,
                hintText: "Email",
                controller: emailController,
                validationType: InputValidationType.email,
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  SizedBox(
                    width: 120,
                    child: CountryCodeDropdown(
                      onChanged: (code, flagPath) {
                        setState(() {
                          selectedCountryCode = code;
                          selectedFlag = flagPath;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: CustomInputField(
                      key: phoneKey,
                      hintText: "Phone Number",
                      controller: phoneController,
                      validationType: InputValidationType.phone,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              CustomInputField(
                key: primaryKey,
                hintText: "Make primary contact?",
                isDropdown: true,
                dropdownItems: const ["Yes", "No"],
                selectedItem: selectedPrimary,
                onDropdownChanged: (v) =>
                    setState(() => selectedPrimary = v),
              ),

              const SizedBox(height: 32),

              PrimaryButton(
                text: "Add Contact",
                onPressed: () async {
                  // invoke each field’s built-in validation
                  if (!nameKey.currentState!.validate() ||
                      !relationKey.currentState!.validate() ||
                      !emailKey.currentState!.validate() ||
                      !phoneKey.currentState!.validate() ||
                      !primaryKey.currentState!.validate()) {
                    return;
                  }

                  final uid =
                      FirebaseAuth.instance.currentUser?.uid;
                  if (uid == null) {
                    Get.snackbar("Error", "User not authenticated",
                        backgroundColor:
                        Colors.redAccent.withOpacity(0.5),
                        colorText: Colors.white,
                        duration:
                        const Duration(milliseconds: 1500));
                    return;
                  }

                  try {
                    // find patientRef…
                    final hospitals = await FirebaseFirestore.instance
                        .collection('hospitals')
                        .get();
                    DocumentReference? patientRef;

                    for (final hospital in hospitals.docs) {
                      final patients =
                      hospital.reference.collection('patients');
                      final query = await patients
                          .where('authId', isEqualTo: uid)
                          .limit(1)
                          .get();
                      if (query.docs.isNotEmpty) {
                        patientRef =
                            query.docs.first.reference;
                        break;
                      }
                    }

                    if (patientRef == null) {
                      Get.snackbar("Error",
                          "Patient record not found.",
                          backgroundColor:
                          Colors.redAccent.withOpacity(0.5),
                          colorText: Colors.white,
                          duration:
                          const Duration(milliseconds: 1500));
                      return;
                    }

                    final contact = {
                      'name': nameController.text.trim(),
                      'relation':
                      relationController.text.trim(),
                      'email': emailController.text.trim(),
                      'phone': phoneController.text.trim(),
                      'countryCode': selectedCountryCode,
                      'isPrimary': selectedPrimary == 'Yes',
                      'createdAt':
                      DateTime.now().toIso8601String(),
                    };

                    final doc = await patientRef.get();
                    final data = doc.data() as Map<String, dynamic>? ?? {};

                    // Safely get or initialize emergencyContacts
                    List existing = [];
                    if (data.containsKey('emergencyContacts') &&
                        data['emergencyContacts'] is List) {
                      existing =
                          List.from(data['emergencyContacts']);
                    }

                    // Unset previous primary if needed
                    if (selectedPrimary == 'Yes') {
                      existing = existing.map((c) {
                        c['isPrimary'] = false;
                        return c;
                      }).toList();
                    }

                    existing.add(contact);
                    await patientRef.update({
                      'emergencyContacts': existing,
                    });

                    Get.snackbar("Success",
                        "Emergency contact added successfully!",
                        backgroundColor:
                        UColors.primaryColor,
                        colorText: Colors.white);

                    await Future.delayed(
                        const Duration(milliseconds: 1500));
                    Navigator.pop(context, true);
                  } catch (e) {
                    Get.snackbar("Error",
                        "Failed to add contact: ${e.toString()}",
                        backgroundColor:
                        Colors.redAccent.withOpacity(0.5),
                        colorText: Colors.white);
                  }
                },
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
