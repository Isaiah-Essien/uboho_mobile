import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NotificationService {
  static Future<void> sendNotification({
    required String message,
    required String route,
    required String type,
  }) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final hospitals = await FirebaseFirestore.instance.collection('hospitals').get();

    for (final hospital in hospitals.docs) {
      final patients = await hospital.reference
          .collection('patients')
          .where('authId', isEqualTo: uid)
          .limit(1)
          .get();

      if (patients.docs.isNotEmpty) {
        final patientDoc = patients.docs.first;
        await patientDoc.reference.collection('notifications').add({
          'message': message,
          'timestamp': Timestamp.now(),
          'isRead': false,
          'type': type,
          'route': route,
        });
        break;
      }
    }
  }

  static Future<void> markAsRead(DocumentReference ref) async {
    await ref.update({'isRead': true});
  }
}

//Notification Trigger for High Peak
class SensorNotificationTrigger {
  static bool _motionNotified = false;
  static bool _rotationNotified = false;

  static Future<void> checkAndNotify({required double motion, required double rotation}) async {
    if (motion >= 27 && !_motionNotified) {
      await NotificationService.sendNotification(
        message: '⚠️ High motion intensity detected!',
        route: 'HomeScreen',
        type: 'motion',
      );
      _motionNotified = true;
    }

    if (rotation >= 15 && !_rotationNotified) {
      await NotificationService.sendNotification(
        message: '⚠️ High rotation activity detected!',
        route: 'HomeScreen',
        type: 'rotation',
      );
      _rotationNotified = true;
    }

    // Reset flags if values normalize
    if (motion < 20) _motionNotified = false;
    if (rotation < 10) _rotationNotified = false;
  }
}