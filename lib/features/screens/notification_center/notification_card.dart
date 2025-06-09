import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:uboho/utiils/constants/colors.dart';

class NotificationCard extends StatelessWidget {
  final String message;
  final String time;
  final bool isUnread;

  const NotificationCard({
    Key? key,
    required this.message,
    required this.time,
    this.isUnread = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: UColors.boxHighlightColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Circular icon
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: UColors.primaryColor,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              LucideIcons.activity,
              color: Colors.white,
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          // Message & Time
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  time,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.6),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
