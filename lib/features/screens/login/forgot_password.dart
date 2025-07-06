import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uboho/utiils/constants/text_strings.dart';

import '../../../service_backend/account_login/password_reset_service.dart';
import '../../../utiils/constants/colors.dart';
import '../../reuseable_widgets/onboarding_title_subtitle.dart';
import '../../reuseable_widgets/custom_input.dart';
import '../../reuseable_widgets/primary_button.dart';
import '../login/login.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final TextEditingController idOrEmailController = TextEditingController();
  final GlobalKey<CustomInputFieldState> emailKey =
  GlobalKey<CustomInputFieldState>();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
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
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.only(top: 16),
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
                      ),
                      const SizedBox(height: 20),
                      OnboardingTitleSubtitle(
                        title: UTexts.verifyScreenTitle,
                        subtitle: UTexts.verifyScreenSubTitle,
                      ),
                      const SizedBox(height: 32),
                      CustomInputField(
                        key: emailKey,
                        hintText: 'Patient ID or Email',
                        controller: idOrEmailController,
                        validationType: InputValidationType.none,
                      ),
                      const SizedBox(height: 24),
                      isLoading
                          ? const Center(
                        child: CircularProgressIndicator(
                          color: UColors.primaryColor,
                        ),
                      )
                          : PrimaryButton(
                        text: 'Submit',
                        onPressed: () async {
                          if (!emailKey.currentState!.validate()) return;

                          final input = idOrEmailController.text.trim();

                          setState(() => isLoading = true);

                          try {
                            final resetEmail =
                            await PasswordResetService.sendResetEmail(
                                input);

                            setState(() => isLoading = false);

                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (context) {
                                return Dialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius.circular(16),
                                  ),
                                  backgroundColor:
                                  UColors.boxHighlightColor,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 24, vertical: 32),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Text(
                                          'Reset Link Sent!',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(height: 16),
                                        Text(
                                          'Check Your Email: A password reset link has been sent to:\n$resetEmail',
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                          ),
                                        ),
                                        const SizedBox(height: 24),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                            UColors.primaryColor,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                              BorderRadius.circular(
                                                  10),
                                            ),
                                            minimumSize:
                                            const Size.fromHeight(45),
                                          ),
                                          onPressed: () {
                                            Get.offAll(() =>
                                            const LoginScreen());
                                          },
                                          child: const Text(
                                            'Go to Login',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          } catch (e) {
                            setState(() => isLoading = false);
                            Get.snackbar(
                              'Error',
                              e.toString(),
                              snackPosition: SnackPosition.BOTTOM,
                            );
                          }
                        },
                      ),
                      const Spacer(),
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
