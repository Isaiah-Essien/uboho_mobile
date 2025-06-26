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
        print('SMTP credentials missing in .env');
        return;
      }

      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

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
          final contacts = List<Map<String, dynamic>>.from(patientDoc['emergencyContacts'] ?? []);
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
          print('Primary contact email: $recipientEmail');
          break;
        }
      }

      if (recipientEmail == null || recipientEmail.isEmpty) {
        print('No email found');
        return;
      }

      final smtpServer = gmail(gmailAddress, gmailPassword);

      final mapsLink = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';

      final message = Message()
        ..from = Address(gmailAddress, 'Uboho Alert System')
        ..recipients.add(recipientEmail)
        ..subject = '🚨 Seizure Alert for $patientName'
        ..html = '''
        <div style="font-family: sans-serif; padding: 20px; background-color: #f7f7f7;">
          <div style="max-width: 600px; margin: auto; background-color: white; border-radius: 10px; overflow: hidden; box-shadow: 0 0 8px rgba(0,0,0,0.1);">
            <div style="background-color: #672BB5; padding: 20px; text-align: center;">
              <img src="https://raw.githubusercontent.com/Isaiah-Essien/uboho_mobile/main/assets/logos/primary.png
" alt="Uboho Logo" height="40" />
              <h2 style="color: white; margin: 10px 0 0;">Seizure Alert</h2>
            </div>
            <div style="padding: 20px; color: #333;">
              <p><strong>Patient:</strong> $patientName</p>
              <p>A seizure event has just been detected.</p>
              <p><strong>Live Location:</strong><br>
                <a href="$mapsLink" style="color: #672BB5;">$mapsLink</a>
              </p>
              <p>Please check on the patient immediately or notify emergency services.</p>
              <br>
              <p style="font-size: 12px; color: gray;">This message was sent by the Uboho system for emergency purposes.</p>
            </div>
          </div>
        </div>
        ''';

      final sendReport = await send(message, smtpServer);
      print('Email sent: $sendReport');
    } catch (e) {
      print('Email failed: $e');
    }
  }
}
