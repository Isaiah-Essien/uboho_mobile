import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PasswordResetService {
  /// Accepts either a patientId or email, looks up the patient's email,
  /// sends Firebase reset email, then wraps it in a custom HTML template via SMTP.
  static Future<String> sendResetEmail(String patientIdOrEmail) async {
    try {
      // Step 1: Check .env credentials
      final email = dotenv.env['GMAIL_ADDRESS'];
      final password = dotenv.env['GMAIL_PASSWORD'];
      final apiKey = dotenv.env['FIREBASE_WEB_APIKEY'];

      if (email == null || password == null || apiKey == null) {
        throw Exception('Missing GMAIL_ADDRESS, GMAIL_PASSWORD or FIREBASE_WEB_APIKEY');
      }

      // Step 2: Resolve the actual patient email
      String? foundEmail;
      String? patientName;

      final hospitals = await FirebaseFirestore.instance.collection('hospitals').get();
      for (final hospital in hospitals.docs) {
        final patients = await hospital.reference.collection('patients').get();

        for (final doc in patients.docs) {
          final data = doc.data();
          final patientEmail = data['email']?.toString().trim().toLowerCase();
          final patientId = doc.id.trim().toLowerCase();

          if (patientEmail == patientIdOrEmail.toLowerCase() || patientId == patientIdOrEmail.toLowerCase()) {
            foundEmail = patientEmail;
            patientName = data['name'] ?? 'Patient';
            break;
          }
        }

        if (foundEmail != null) break;
      }

      if (foundEmail == null) {
        throw Exception("No patient found with that email or ID.");
      }

      // Step 3: Send Firebase Auth password reset link
      await FirebaseAuth.instance.sendPasswordResetEmail(email: foundEmail);

      // Step 4: Compose custom HTML email
      final resetLink = 'https://identitytoolkit.googleapis.com/v1/accounts:sendOobCode?key=$apiKey';
      final smtpServer = gmail(email, password);

      final message = Message()
        ..from = Address(email, 'Uboho Password Reset')
        ..recipients.add(foundEmail)
        ..subject = '🔐 Reset Your Uboho Password'
        ..html = '''
<!DOCTYPE html>
<html>
  <body style="font-family: Arial, sans-serif; margin: 0; padding: 0; background: #f9f9f9;">
    <div style="max-width: 600px; margin: auto; border: 1px solid #eee; background: #fff; border-radius: 8px; overflow: hidden;">
      <div style="background-color: #672BB5; padding: 20px; text-align: center; color: white;">
        <img src="https://raw.githubusercontent.com/Isaiah-Essien/uboho_mobile/main/assets/logos/white.png" alt="Uboho Logo" width="80" height="80" style="margin-bottom: 8px;" />
        <h2 style="margin: 0;">Uboho Password Reset</h2>
      </div>
      <div style="padding: 20px; color: #1E1E1E;">
        <p>Dear $patientName,</p>
        <p>You requested to reset your Uboho account password.</p>
        <p>Please click the button below to proceed:</p>
        <p style="text-align: center; margin: 20px 0;">
          <a href="https://uboho-b3934.firebaseapp.com/" target="_blank" style="background-color: #672BB5; color: white; padding: 12px 24px; text-decoration: none; border-radius: 5px;">
            Reset Password
          </a>
        </p>
        <p>If you didn't request this, you can safely ignore this email.</p>
        <p style="margin-top: 30px;">With Love,<br><strong>Uboho Team</strong></p>
      </div>
      <div style="padding: 10px; text-align: center; background-color: #f1f1f1;">
        <p style="font-size: 12px; color: #888;">
          This message was sent by the Uboho system for password assistance.
        </p>
      </div>
    </div>
  </body>
</html>
      ''';

      await send(message, smtpServer);
      return foundEmail;
    } catch (e) {
      throw Exception('Password reset failed: $e');
    }
  }
}
