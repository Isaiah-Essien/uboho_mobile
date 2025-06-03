import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/onboarding_controller.dart';
import 'onboarding1.dart';
import 'onboarding2.dart';
import 'onboarding3.dart';

class OnboardingScreen extends StatelessWidget {
  OnboardingScreen({super.key});

  final onboardingController = Get.find<OnboardingController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: onboardingController.pageController,
        onPageChanged: onboardingController.updateIndex,
        children:  const [
          MeetUboho(),
          TrackSeizure(),
          AlwaysHere(),
        ],
      ),
    );
  }
}
