import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:uboho/features/screens/onboarding/onboarding_screen.dart';
import 'package:uboho/utiils/constants/text_strings.dart';

import '../../../service_backend/account_creation/patient_account_creation_controller.dart';
import '../../../utiils/constants/colors.dart';
import '../../controllers/create_account_controller.dart';
import '../../controllers/onboarding_controller.dart';
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

    final GlobalKey<CustomInputFieldState> hospitalKey = GlobalKey<CustomInputFieldState>();
    final GlobalKey<CustomInputFieldState> idOrEmailKey = GlobalKey<CustomInputFieldState>();
    final GlobalKey<CustomInputFieldState> passwordKey = GlobalKey<CustomInputFieldState>();

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
                      // Back icon
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
                              final onboardingController = Get.find<OnboardingController>();
                              onboardingController.resetToFirstPage();
                              Get.offAll(() => OnboardingScreen());
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

                      // Hospital Dropdown
                      Obx(() {
                        return CustomInputField(
                          key: hospitalKey,
                          hintText: 'Select Hospital/organization',
                          isDropdown: true,
                          dropdownItems: controller.hospitals,
                          selectedItem: controller.selectedDropdownItem.value,
                          onDropdownChanged: (value) {
                            controller.selectDropdownItem(value);
                          },
                        );
                      }),

                      const SizedBox(height: 16),

                      CustomInputField(
                        key: idOrEmailKey,
                        hintText: 'Patient ID or Email',
                        controller: controller.patientIdController,
                      ),

                      const SizedBox(height: 16),

                      CustomInputField(
                        key: passwordKey,
                        hintText: 'Create Password',
                        isPassword: true,
                        controller: controller.passwordController,
                        validationType: InputValidationType.password,
                      ),

                      const SizedBox(height: 24),

                      PrimaryButton(
                        text: 'Access My Dashboard',
                        onPressed: () {
                          if (!hospitalKey.currentState!.validate() ||
                              !idOrEmailKey.currentState!.validate() ||
                              !passwordKey.currentState!.validate()) {
                            return;
                          }

                          PatientAccountController.activateAccountWithPassword(
                            selectedHospitalName: controller.selectedDropdownItem.value ?? '',
                            patientInput: controller.patientIdController.text.trim(),
                            password: controller.passwordController.text.trim(),
                            context: context,
                          );
                        },
                      ),

                      const SizedBox(height: 16),

                      Row(
                        children: const [
                          Expanded(child: Divider(color: UColors.dividerColor)),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Text("OR", style: TextStyle(color: UColors.dividerColor)),
                          ),
                          Expanded(child: Divider(color: UColors.dividerColor)),
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
                          'Privacy Policy': () async {
                            await showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              useRootNavigator: true,
                              backgroundColor: Colors.black,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                              ),
                              builder: (context) {
                                return DraggableScrollableSheet(
                                  expand: false,
                                  initialChildSize: 0.85,
                                  maxChildSize: 0.95,
                                  minChildSize: 0.6,
                                  builder: (_, scrollController) {
                                    return Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                          child: Row(
                                            children: [
                                              const Text(
                                                "Privacy Policy",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                ),
                                              ),
                                              const Spacer(),
                                              IconButton(
                                                icon: const Icon(Icons.close, color: Colors.white),
                                                onPressed: () => Navigator.pop(context),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const Divider(color: Colors.white24, height: 1),
                                        Expanded(
                                          child: SfPdfViewer.asset(
                                            'assets/docs/Uboho_app_privacy_ethics_docs.pdf',
                                            canShowScrollHead: false,
                                            canShowScrollStatus: false,
                                            onDocumentLoaded: (details) {
                                              debugPrint('PDF loaded successfully');
                                            },
                                            onDocumentLoadFailed: (details) {
                                              debugPrint('PDF load failed: ${details.description}');
                                              Get.snackbar(
                                                'Error',
                                                'Failed to load privacy document',
                                                backgroundColor: Colors.red,
                                                colorText: Colors.white,
                                                snackPosition: SnackPosition.BOTTOM,
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            );
                          },
                          'Terms & Conditions': () {
                            // Future: Add your terms logic
                          },
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
