import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uboho/utiils/constants/colors.dart';
import 'notification_card.dart';

class NotificationCenterScreen extends StatelessWidget {
  const NotificationCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy data (you can later replace with data from Firestore or local state)
    final unreadNotifications = [
      {
        'message': 'Peak activity detected — review recent motion history.',
        'time': '2 mins ago'
      },
    ];

    final readNotifications = List.generate(8, (index) => {
      'message': 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt.',
      'time': '2 mins ago'
    });

    return Scaffold(
      backgroundColor: UColors.backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top bar without AppBar
              Row(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      color: UColors.boxHighlightColor,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.chevron_left, color: Colors.white),
                      onPressed: () => Get.back(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      "Notification",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(width: 58), // Reserve space to center the title
                ],
              ),

              const SizedBox(height: 28),

              // Unread Section
              const Text(
                "Unread",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              ...unreadNotifications.map((notif) => NotificationCard(
                message: notif['message']!,
                time: notif['time']!,
                isUnread: true,
              )),

              const SizedBox(height: 20),

              // Read Section
              const Text(
                "Read",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: ListView(
                  children: readNotifications
                      .map((notif) => NotificationCard(
                    message: notif['message']!,
                    time: notif['time']!,
                  ))
                      .toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
