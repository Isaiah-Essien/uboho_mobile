// Create a new file: login_patient_controller.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../utiils/navigations/main_nav.dart';

class PatientLoginController {
  static Future<void> loginPatient({
    required String input,
    required String password,
    required BuildContext context,
  }) async {
    try {
      final FirebaseAuth auth = FirebaseAuth.instance;
      final FirebaseFirestore firestore = FirebaseFirestore.instance;

      String? email;

      // Step 1: Loop through hospitals to find matching patient
      final hospitalsSnapshot = await firestore.collection('hospitals').get();

      for (final hospital in hospitalsSnapshot.docs) {
        final patientsRef = hospital.reference.collection('patients');

        // Determine if input is email or patient ID
        if (input.contains('@')) {
          // Search by email
          final emailQuery = await patientsRef.where('email', isEqualTo: input).limit(1).get();
          if (emailQuery.docs.isNotEmpty) {
            email = emailQuery.docs.first['email'];
            break;
          }
        } else {
          // Search by patient ID (doc ID)
          final idDoc = await patientsRef.doc(input).get();
          if (idDoc.exists) {
            email = idDoc['email'];
            break;
          }
        }
      }

      // Step 2: If email was resolved, attempt login
      if (email == null) {
        _showError(context, "We could not find a patient matching that ID or email.");
        return;
      }

      await auth.signInWithEmailAndPassword(email: email, password: password);

      // Step 3: Navigate to Home/Dashboard
      Get.offAll(() => const MainNavigation());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        _showError(context, "No user found for that email. Please check your hospital.");
      } else if (e.code == 'wrong-password') {
        _showError(context, "Incorrect password. Please try again.");
      } else {
        _showError(context, "Login error: ${e.message}");
      }
    } catch (e) {
      _showError(context, "Unexpected error: ${e.toString()}");
    }
  }

  static void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
