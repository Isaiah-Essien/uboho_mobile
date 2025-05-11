import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uboho/utiils/constants/colors.dart';
import 'package:uboho/utiils/constants/text_strings.dart';
import '../../controllers/opt_controller.dart';
import '../../reuseable_widgets/custom_input.dart';
import '../../reuseable_widgets/onboarding_title_subtitle.dart';
import '../../reuseable_widgets/primary_button.dart';
import 'new_password.dart';

class OtpScreen extends StatelessWidget {
  final String email; // pass this in when routing from ForgotPassword

  const OtpScreen({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    final otpCodeController = TextEditingController();
    final controller = Get.put(OTPController());

    controller.setEmail(email);
    controller.startCountdown();

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
                            icon: const Icon(Icons.chevron_left, color: Colors.white),
                            onPressed: () => Get.back(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      OnboardingTitleSubtitle(
                        title: UTexts.otpScreenTitle,
                        subtitle:
                        'We’ve sent an OTP code, please check your email ${controller.userEmail}',
                      ),

                      const SizedBox(height: 32),

                      CustomInputField(
                        hintText: 'Code',
                        controller: otpCodeController,
                      ),

                      const SizedBox(height: 24),

                      PrimaryButton(
                        text: 'Verify Code',
                        onPressed: () =>Get.to(NewPasswordScreen()),
                      ),

                      const SizedBox(height: 20),

                      Obx(() => Center(
                        child: controller.secondsLeft.value > 0
                            ? Text(
                          'Resend in ${controller.secondsLeft.value}s',
                          style: const TextStyle(color: Colors.white54, fontWeight: FontWeight.w600),
                        )
                            : TextButton(
                          onPressed: controller.resendCode,
                          child: const Text(
                            'Resend Code',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      )),
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
