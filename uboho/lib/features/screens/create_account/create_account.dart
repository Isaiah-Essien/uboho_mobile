import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utiils/constants/colors.dart';

import '../../reuseable_widgets/custom_input.dart';
import '../../reuseable_widgets/long_line_footer.dart';
import '../../reuseable_widgets/primary_button.dart';
import '../login/login.dart';



class CreateAccountScreen extends StatelessWidget {
  const CreateAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController hospitalController = TextEditingController();
    final TextEditingController patientIdController = TextEditingController();
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
                'Create Account',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 12),
              const Text(
                'Set up your profile to unlock real-time monitoring, personalized alerts, and around-the-clock support.',
                style: TextStyle(color: Colors.white70),
              ),

              const SizedBox(height: 32),
              CustomInputField(
                hintText: 'Select Hospital/organization',
                isDropdown: true,
                controller: hospitalController,
                onTap: () {
                  // open dropdown sheet or page
                },
              ),
              const SizedBox(height: 16),
              CustomInputField(
                hintText: 'Patient ID',
                controller: patientIdController,
              ),
              const SizedBox(height: 16),
              CustomInputField(
                hintText: 'Create Password',
                isPassword: true,
                controller: passwordController,
              ),

              const SizedBox(height: 24),
              PrimaryButton(
                text: 'Access My Dashboard',
                onPressed: () {
                  // Handle account creation
                },
              ),

              const SizedBox(height: 16),
              Row(children: const [
                Expanded(child: Divider(color: Colors.white24)),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text("OR", style: TextStyle(color: Colors.white)),
                ),
                Expanded(child: Divider(color: Colors.white24)),
              ]),
              const SizedBox(height: 16),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(50),
                  side: const BorderSide(color: Colors.white),
                ),
                onPressed: () => Get.to(() => const LoginScreen()),
                child: const Text('Have an account? Login'),
              ),

              const Spacer(),

              FooterText(
                text: 'Read our',
                linkText: 'Privacy Policy and Terms & Conditions',
                onTap: () {
                  // Show terms
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
