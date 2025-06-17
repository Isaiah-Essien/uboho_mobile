import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UnreadMessageChecker {
  static Future<bool> hasUnreadMessages() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return false;

    final uid = user.uid;

    // Search all hospitals for the matching patient document
    final hospitalsSnap = await FirebaseFirestore.instance.collection('hospitals').get();

    for (final hospitalDoc in hospitalsSnap.docs) {
      final patientsSnap = await hospitalDoc.reference
          .collection('patients')
          .where('authId', isEqualTo: uid)
          .limit(1)
          .get();

      if (patientsSnap.docs.isNotEmpty) {
        final patientId = patientsSnap.docs.first.id;

        final conversationsSnap = await hospitalDoc.reference.collection('conversations').get();
        for (final convo in conversationsSnap.docs) {
          final participants = List<String>.from(convo['participants'] ?? []);
          if (participants.contains(patientId)) {
            final unreadCount = convo['unreadCount']?[patientId];
            if (unreadCount != null && unreadCount > 0) {
              return true;
            }
          }
        }
      }
    }

    return false;
  }
}
