// widgets/onboarding_dot_navigation.dart
import 'package:flutter/material.dart';
import '../../utiils/constants/colors.dart';

class OnboardingDotNavigation extends StatelessWidget {
  final int activeIndex;

  const OnboardingDotNavigation({super.key, required this.activeIndex});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(3, (index) {
        final isActive = index == activeIndex;
        return Container(
          margin: const EdgeInsets.only(right: 6),
          width: 50,
          height: 6,
          decoration: BoxDecoration(
            color: isActive ? UColors.primaryColor : Colors.grey.shade700,
            borderRadius: BorderRadius.circular(10),
          ),
        );
      }),
    );
  }
}
