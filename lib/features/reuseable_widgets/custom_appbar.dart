import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../utiils/constants/colors.dart';

class CustomAppBar extends StatelessWidget {
  final String? title;
  final VoidCallback? onBackTap;
  final VoidCallback? onRightTap;
  final IconData? rightIcon;

  const CustomAppBar({
    super.key,
    this.title,
    this.onBackTap,
    this.onRightTap,
    this.rightIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          // Left icon
          GestureDetector(
            onTap: onBackTap ?? () => Get.back(),
            child: Container(
              decoration: BoxDecoration(
                color: UColors.boxHighlightColor,
                shape: BoxShape.circle,
              ),
              padding: const EdgeInsets.all(8),
              child: const Icon(Icons.chevron_left, color: Colors.white),
            ),
          ),

          // Title
          Expanded(
            child: Center(
              child: title != null
                  ? Text(
                title!,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
              )
                  : const SizedBox.shrink(),
            ),
          ),

          // Right icon (optional)
          if (rightIcon != null)
            GestureDetector(
              onTap: onRightTap ?? () {},
              child: Container(
                decoration: BoxDecoration(
                  color: UColors.boxHighlightColor,
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(8),
                child: Icon(rightIcon, color: Colors.white),
              ),
            )
          else
            const SizedBox(width: 40), // Placeholder to balance layout
        ],
      ),
    );
  }
}
