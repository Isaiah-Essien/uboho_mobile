import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uboho/features/reuseable_widgets/custom_input.dart';
import 'package:uboho/features/reuseable_widgets/onboarding_title_subtitle.dart';
import 'package:uboho/features/reuseable_widgets/primary_button.dart';
import 'package:uboho/utiils/constants/colors.dart';

import '../../reuseable_widgets/country_code_picker.dart'; // <-- your new widget

class AddEmergencyContactScreen extends StatefulWidget {
  const AddEmergencyContactScreen({super.key});

  @override
  State<AddEmergencyContactScreen> createState() => _AddEmergencyContactScreenState();
}

class _AddEmergencyContactScreenState extends State<AddEmergencyContactScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController relationController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  String? selectedPrimary;
  String selectedCountryCode = '+250';
  String selectedFlag = 'rwanda_flag.webp';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UColors.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
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
                  icon: const Icon(Icons.chevron_left, color: Colors.white),
                  onPressed: () => Get.back(),
                ),
              ),

              const SizedBox(height: 20),

              const OnboardingTitleSubtitle(
                title: "New Contact",
                subtitle:
                "Set up a new emergency contact! We will reach out to them incase you need help",
              ),

              const SizedBox(height: 32),

              CustomInputField(hintText: "Full Names", controller: nameController),
              const SizedBox(height: 16),

              CustomInputField(hintText: "Relation", controller: relationController),
              const SizedBox(height: 16),

              CustomInputField(hintText: "Email", controller: emailController),
              const SizedBox(height: 16),

              // Country Code Dropdown + Phone Number Input
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
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: Colors.white24),
                        color: UColors.boxHighlightColor,
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: TextField(
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: "Phone Number",
                          hintStyle: TextStyle(color: Colors.white70),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              CustomInputField(
                hintText: "Make primary contact?",
                isDropdown: true,
                dropdownItems: const ["Yes", "No"],
                selectedItem: selectedPrimary,
                onDropdownChanged: (value) {
                  setState(() {
                    selectedPrimary = value;
                  });
                },
              ),

              const SizedBox(height: 32),

              PrimaryButton(
                text: "Add Contact",
                onPressed: () {
                  // TODO: Add contact logic
                  print("Name: ${nameController.text}");
                  print("Phone: $selectedCountryCode ${phoneController.text}");
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
