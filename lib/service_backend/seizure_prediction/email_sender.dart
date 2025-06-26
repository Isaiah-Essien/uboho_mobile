import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class EmailSender {
  static Future<void> sendSeizureAlertEmail({
    required double latitude,
    required double longitude,
    required String patientName,
  }) async {
    try {
      final gmailAddress = dotenv.env['GMAIL_ADDRESS'];
      final gmailPassword = dotenv.env['GMAIL_PASSWORD'];
      if (gmailAddress == null || gmailPassword == null) {
        print('SMTP credentials not found in .env file');
        return;
      }

      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        print('No user is currently logged in.');
        return;
      }

      final uid = user.uid;
      final hospitals = await FirebaseFirestore.instance.collection('hospitals').get();
      String? recipientEmail;

      for (final hospital in hospitals.docs) {
        final patientsSnapshot = await hospital.reference
            .collection('patients')
            .where('authId', isEqualTo: uid)
            .limit(1)
            .get();

        if (patientsSnapshot.docs.isNotEmpty) {
          final patientDoc = patientsSnapshot.docs.first;

          final contacts = List<Map<String, dynamic>>.from(
              patientDoc.data()['emergencyContacts'] ?? []);
          if (contacts.isEmpty) continue;

          var primaryIdx = contacts.indexWhere((c) => c['isPrimary'] == true);
          if (primaryIdx < 0 || contacts.where((c) => c['isPrimary'] == true).length > 1) {
            for (var i = 0; i < contacts.length; i++) {
              contacts[i]['isPrimary'] = (i == 0);
            }
            await patientDoc.reference.update({'emergencyContacts': contacts});
            primaryIdx = 0;
          }

          recipientEmail = contacts[primaryIdx]['email'];
          print('Primary contact email resolved: $recipientEmail');
          break;
        }
      }

      if (recipientEmail == null || recipientEmail.isEmpty) {
        print('No primary contact email found.');
        return;
      }

      final mapsLink = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';

      final smtpServer = gmail(gmailAddress, gmailPassword);
      final message = Message()
        ..from = Address(gmailAddress, 'Uboho Alert System')
        ..recipients.add(recipientEmail)
        ..subject = '🚨 Seizure Alert for $patientName'
        ..html = '''
<!DOCTYPE html>
<html>
  <body style="font-family: Arial, sans-serif; margin: 0; padding: 0; background: #f9f9f9;">
    <div style="max-width: 600px; margin: auto; border: 1px solid #eee; background: #fff; border-radius: 8px; overflow: hidden;">
      <div style="background-color: #672BB5; padding: 20px; text-align: center; color: white;">
        <img src="https://raw.githubusercontent.com/Isaiah-Essien/uboho_mobile/main/assets/logos/white.png" alt="Uboho Logo" width="80" height="80" style="margin-bottom: 8px;" />
        <h2 style="margin: 0;">Uboho Seizure Alert</h2>
      </div>
      <div style="padding: 20px; color: #1E1E1E;">
        <p>Dear Emergency contact,</p>
        <p>We have detected a potential seizure event for <strong>$patientName</strong>.</p>
        <p>Please check in immediately or contact a medical service. Below is the last known location of the patient:</p>
        <p><a href="$mapsLink" target="_blank">$mapsLink</a></p>
        <p style="margin-top: 30px;">With Love,<br><strong>Uboho Team</strong></p>
      </div>
      <div style="padding: 10px; text-align: center; background-color: #f1f1f1;">
        <p style="font-size: 12px; color: #888;">
          This message was sent by the Uboho system for emergency purposes.
        </p>
      </div>
    </div>
  </body>
</html>
        ''';

      final sendReport = await send(message, smtpServer);
      print(' Email sent: $sendReport');
    } catch (e) {
      print('Failed to send email: $e');
    }
  }
}
