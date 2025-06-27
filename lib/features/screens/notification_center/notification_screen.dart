import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uboho/utiils/constants/colors.dart';
import '../../../service_backend/settiings_logics/notification_service.dart';
import 'notification_card.dart';
import 'package:intl/intl.dart';

class NotificationCenterScreen extends StatelessWidget {
  const NotificationCenterScreen({super.key});

  Future<Query<Map<String, dynamic>>?> _getNotificationQuery() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return null;

    final hospitals = await FirebaseFirestore.instance.collection('hospitals').get();

    for (final hospital in hospitals.docs) {
      final patients = await hospital.reference
          .collection('patients')
          .where('authId', isEqualTo: uid)
          .limit(1)
          .get();

      if (patients.docs.isNotEmpty) {
        final patientRef = patients.docs.first.reference;
        return patientRef.collection('notifications')
            .orderBy('timestamp', descending: true);
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UColors.backgroundColor,
      body: SafeArea(
        child: FutureBuilder<Query<Map<String, dynamic>>?>(
          future: _getNotificationQuery(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            final query = snapshot.data!;
            return StreamBuilder<QuerySnapshot>(
              stream: query.snapshots(),
              builder: (context, snap) {
                if (!snap.hasData) return const Center(child: CircularProgressIndicator());

                final all = snap.data!.docs;
                final unread = all.where((doc) => !(doc['isRead'] ?? false)).toList();
                final read = all.where((doc) => doc['isRead'] ?? false).toList();

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Top bar
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
                          const SizedBox(width: 58),
                        ],
                      ),

                      const SizedBox(height: 28),
                      const Text("Unread", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 12),

                      ...unread.map((doc) {
                        final time = (doc['timestamp'] as Timestamp).toDate();
                        return NotificationCard(
                          message: doc['message'],
                          time: DateFormat('MMM d, h:mm a').format(time),
                          isUnread: true,
                          onTap: () {
                            NotificationService.markAsRead(doc.reference);
                            Get.toNamed('/${doc['route']}');
                          },
                        );
                      }),

                      const SizedBox(height: 20),
                      const Text("Read", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 12),

                      Expanded(
                        child: ListView(
                          children: read.map((doc) {
                            final time = (doc['timestamp'] as Timestamp).toDate();
                            return NotificationCard(
                              message: doc['message'],
                              time: DateFormat('MMM d, h:mm a').format(time),
                              onTap: () => Get.toNamed('/${doc['route']}'),
                            );
                          }).toList(),
                        ),
                      )
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
