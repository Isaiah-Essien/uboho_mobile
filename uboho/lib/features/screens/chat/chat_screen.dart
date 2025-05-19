import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:uboho/features/reuseable_widgets/onboarding_title_subtitle.dart';
import 'package:uboho/utiils/constants/colors.dart';
import 'package:uboho/utiils/constants/icons.dart';
import 'package:uboho/utiils/constants/text_strings.dart';

import 'chat_with_med_staff.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UColors.backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              OnboardingTitleSubtitle(
                  title: UTexts.chatTitle,
                  subtitle: UTexts.chatSubTitle
              ),
              const SizedBox(height: 24),

              // Chat with medical staff
              _buildChatTile(
                iconPath: UIcons.uVector,
                label: 'Chat with a medical staff',
                onTap: ()=>Get.to(ChatWithMedicalStaffScreen()),
              ),

              const SizedBox(height: 16),

              // Contact Tech Support
              _buildChatTile(
                iconPath: UIcons.uVector,
                label: 'Contact Tech Support',
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChatTile({
    required String iconPath,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        decoration: BoxDecoration(
          color: UColors.boxHighlightColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            // U Logo in circular black container
            Container(
              width: 48,
              height: 48,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: UColors.backgroundColor,
              ),
              padding: const EdgeInsets.all(4),
              child: SvgPicture.asset(
                iconPath,
                height: 24,
                width: 29.35,
                fit: BoxFit.contain,
              ),
            ),

            const SizedBox(width: 16),

            // Label
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),

            // Right Arrow
            const Icon(
              LucideIcons.chevronRight,
              color: Colors.white,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }
}
