import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utiils/constants/colors.dart';

import '../../reuseable_widgets/custom_input.dart';
import '../../reuseable_widgets/long_line_footer.dart';
import '../../reuseable_widgets/primary_button.dart';

import '../create_account/create_account.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController idOrEmailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    return Scaffold(
      backgroundColor: UColors.backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              const BackButton(color: Colors.white),

              const SizedBox(height: 30),
              const Text(
                'Welcome back!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 12),
              const Text(
                "Let's get you back to monitoring safely and staying in control—your health journey continues here.",
                style: TextStyle(color: Colors.white70),
              ),

              const SizedBox(height: 32),
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
              PrimaryButton(
                text: 'Login',
                onPressed: () {
                  // Handle login
                },
              ),

              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {},
                  child: const Text('Forgot Password?', style: TextStyle(color: Colors.white70)),
                ),
              ),

              const Spacer(),

              FooterText(
                text: "Don't have an account?",
                linkText: "Sign Up",
                onTap: () => Get.to(() => const CreateAccountScreen()),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
