import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utiils/constants/colors.dart';
import '../../../utiils/constants/text_strings.dart';

import '../../../utiils/navigations/main_nav.dart';
import '../../reuseable_widgets/custom_input.dart';
import '../../reuseable_widgets/long_line_footer.dart';
import '../../reuseable_widgets/onboarding_title_subtitle.dart';
import '../../reuseable_widgets/primary_button.dart';
import '../create_account/create_account.dart';
import 'forgot_password.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController idOrEmailController = TextEditingController();
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
                      OnboardingTitleSubtitle(
                        title: UTexts.loginTitle,
                        subtitle: UTexts.loginSubtitle,
                      ),

                      const SizedBox(height: 32),

                      // Input Fields
                      CustomInputField(
                        hintText: 'Patient ID or Email',
                        controller: idOrEmailController,
                      ),
                      const SizedBox(height: 16),
                      CustomInputField(
                        hintText: 'Password',
                        isPassword: true,
                        controller: passwordController,
                      ),

                      const SizedBox(height: 24),

                      // Login Button
                      PrimaryButton(
                        text: 'Login',
                        onPressed: () {
                          // Handle login
                          Get.offAll(() => const MainNavigation());
                        },
                      ),

                      const SizedBox(height: 8),

                      // Forgot Password
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () =>Get.to(ForgotPassword()),
                          child: const Text(
                            'Forgot Password?',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),

                      const Spacer(),


                      // Footer
                      FooterText(
                        fullText: 'Don’t have an account? Sign Up',
                        links: {
                          'Sign Up': () => Get.to(() => const CreateAccountScreen()),
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
