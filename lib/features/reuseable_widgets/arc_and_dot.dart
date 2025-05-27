// widgets/decorative_arc_and_dot.dart
import 'package:flutter/material.dart';
import '../../utiils/constants/colors.dart';
import '../../utiils/constants/image_strings.dart';

class OnboardingArc extends StatelessWidget {
  const OnboardingArc({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: -11, // allow to overflow
      right: 35,
      child: Image.asset(
        UImages.arc,
        width: 119.98,
        height: 59.88,
        fit: BoxFit.contain,
      ),
    );
  }
}

class OnboardingSmallDot extends StatelessWidget {
  const OnboardingSmallDot({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: -12, // now visible
      right: 165,
      child: Container(
        width: 11.02,
        height: 11.02,
        decoration: BoxDecoration(
          color: UColors.onboardingDotColor,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

