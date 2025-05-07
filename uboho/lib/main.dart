import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app.dart';
import 'features/controllers/onboarding_controller.dart';

Future<void> main() async {
  // Ensure Widgets Binding is initialized
  WidgetsFlutterBinding.ensureInitialized();


  //Declare state management: GetX
  Get.put(OnboardingController());

  // Run the app
  runApp(const App());
}
