import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uboho/utiils/constants/colors.dart';
import 'package:uboho/utiils/constants/text_strings.dart';
import 'package:uboho/utiils/popups/new_password_popup.dart';
import '../../reuseable_widgets/onboarding_title_subtitle.dart';
import '../../reuseable_widgets/custom_input.dart';
import '../../reuseable_widgets/primary_button.dart';
import '../login/login.dart';

class NewPasswordScreen extends StatelessWidget {
  const NewPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController passwordController = TextEditingController();

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
                      // Top back icon
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

                      // Title + Subtitle
                      const OnboardingTitleSubtitle(
                        title: UTexts.newPasswordTitle,
                        subtitle: UTexts.newPasswordSubTitle,
                      ),

                      const SizedBox(height: 32),

                      // Password Field
                      CustomInputField(
                        hintText: 'Password',
                        isPassword: true,
                        controller: passwordController,
                      ),

                      const SizedBox(height: 24),

                      // Submit Button
                      PrimaryButton(
                        text: 'Change Password',
                        onPressed: () {
                          // Navigate to popup or success screen here
                          showPasswordUpdatedPopup(context);
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
