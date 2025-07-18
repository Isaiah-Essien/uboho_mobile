import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:uboho/utiils/constants/colors.dart';

class NotificationCard extends StatelessWidget {
  final String message;
  final String time;
  final bool isUnread;
  final VoidCallback? onTap;

  const NotificationCard({
    Key? key,
    required this.message,
    required this.time,
    this.isUnread = false,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // Navigation or update logic
      child: Container(
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

            // Message and Time
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          message,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      if (isUnread)
                        Container(
                          margin: const EdgeInsets.only(left: 6, top: 2),
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: UColors.primaryColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
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
      ),
    );
  }
}
