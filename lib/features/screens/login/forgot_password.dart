import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uboho/utiils/constants/text_strings.dart';

import '../../../utiils/constants/colors.dart';
import '../../reuseable_widgets/onboarding_title_subtitle.dart';
import '../../reuseable_widgets/custom_input.dart';
import '../../reuseable_widgets/primary_button.dart';
import 'otp_screen.dart';

class ForgotPassword extends StatelessWidget {
  const ForgotPassword({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController idOrEmailController = TextEditingController();
    final GlobalKey<CustomInputFieldState> emailKey = GlobalKey<CustomInputFieldState>();

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
                        title: UTexts.verifyScreenTitle,
                        subtitle: UTexts.verifyScreenSubTitle,
                      ),

                      const SizedBox(height: 32),

                      CustomInputField(
                        key: emailKey,
                        hintText: 'Patient ID or Email',
                        controller: idOrEmailController,
                        validationType: InputValidationType.email,
                      ),

                      const SizedBox(height: 24),

                      PrimaryButton(
                        text: 'Submit',
                        onPressed: () {
                          if (!emailKey.currentState!.validate()) return;

                          final email = idOrEmailController.text.trim();
                          Get.to(() => OtpScreen(email: email));
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
