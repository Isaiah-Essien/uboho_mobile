import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uboho/features/screens/onboarding/onboarding1.dart';
import 'package:uboho/features/screens/onboarding/onboarding_screen.dart';
import 'package:uboho/utiils/constants/text_strings.dart';
import '../../../utiils/constants/colors.dart';
import '../../controllers/create_account_controller.dart';
import '../../reuseable_widgets/custom_input.dart';
import '../../reuseable_widgets/long_line_footer.dart';
import '../../reuseable_widgets/onboarding_title_subtitle.dart';
import '../../reuseable_widgets/primary_button.dart';
import '../login/login.dart';

class CreateAccountScreen extends StatelessWidget {
  const CreateAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CreateAccountController());

    final List<String> hospitals = [
      'General Hospital',
      'PeaceCare Clinic',
      'Unity Medical Center',
      'HealthPoint',
    ];

    return Scaffold(
      backgroundColor: UColors.backgroundColor,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Top skip-style back icon
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.only(top: 16),
                          decoration: const BoxDecoration(
                            color: UColors.boxHighlightColor,
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.chevron_left, color: Colors.white),
                            onPressed: () {
                              Get.offAll(() =>  OnboardingScreen());
                            },
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      OnboardingTitleSubtitle(
                        title: UTexts.createAccountTitle,
                        subtitle: UTexts.createAccountSubTitle,
                      ),
                      const SizedBox(height: 32),

                      Obx(() => CustomInputField(
                        hintText: 'Select Hospital/organization',
                        isDropdown: true,
                        dropdownItems: hospitals,
                        selectedItem: controller.selectedDropdownItem.value,
                        onDropdownChanged: controller.selectDropdownItem,
                      )),

                      const SizedBox(height: 16),
                      CustomInputField(
                        hintText: 'Patient ID',
                        controller: controller.patientIdController,
                      ),
                      const SizedBox(height: 16),
                      CustomInputField(
                        hintText: 'Create Password',
                        isPassword: true,
                        controller: controller.passwordController,
                      ),
                      const SizedBox(height: 24),

                      PrimaryButton(
                        text: 'Access My Dashboard',
                        onPressed: () {
                          // handle submit
                        },
                      ),

                      const SizedBox(height: 16),

                      Row(
                        children: [
                          const Expanded(child: Divider(color: UColors.dividerColor)),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Text("OR", style: TextStyle(color: UColors.dividerColor)),
                          ),
                          const Expanded(child: Divider(color: UColors.dividerColor)),
                        ],
                      ),

                      const SizedBox(height: 16),

                      PrimaryButton(
                        text: 'Have an account? Login',
                        color: UColors.boxHighlightColor,
                        onPressed: () {
                          Get.to(() => const LoginScreen());
                        },
                      ),

                      const Spacer(),

                      FooterText(
                        fullText: 'Read our Privacy Policy and Terms & Conditions',
                        links: {
                          'Privacy Policy': () {},
                          'Terms & Conditions': () {},
                        },
                      ),

                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
