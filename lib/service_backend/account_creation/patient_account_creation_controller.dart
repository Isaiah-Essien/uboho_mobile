import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import '../../utiils/navigations/main_nav.dart';
import '../../utiils/constants/colors.dart'; // Import UColors

class PatientAccountController {
  static Future<void> activateAccountWithPassword({
    required String selectedHospitalName,
    required String patientInput, // email or patient ID
    required String password,
    required BuildContext context,
  }) async {
    final firestore = FirebaseFirestore.instance;
    final auth = FirebaseAuth.instance;

    try {
      // Show circular progress indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => Center(
          child: CircularProgressIndicator(color: UColors.primaryColor),
        ),
      );

      // Step 1: Lookup hospital by name
      final hospitalQuery = await firestore
          .collection('hospitals')
          .where('name', isEqualTo: selectedHospitalName)
          .limit(1)
          .get();

      if (hospitalQuery.docs.isEmpty) {
        Navigator.of(context).pop(); // Remove loading
        _showError(context, "Hospital not found.");
        return;
      }

      final hospitalId = hospitalQuery.docs.first.id;
      final patientsRef = firestore
          .collection('hospitals')
          .doc(hospitalId)
          .collection('patients');

      DocumentSnapshot? patientDoc;
      String email = '';
      String docId = '';

      // Step 2: Match patient by email or ID
      if (patientInput.contains('@')) {
        final query = await patientsRef
            .where('email', isEqualTo: patientInput)
            .limit(1)
            .get();

        if (query.docs.isEmpty) {
          Navigator.of(context).pop();
          _showError(context, "No patient with this email in this hospital.");
          return;
        }

        patientDoc = query.docs.first;
        email = patientDoc['email'];
        docId = patientDoc.id;
      } else {
        final doc = await patientsRef.doc(patientInput).get();
        if (!doc.exists) {
          Navigator.of(context).pop();
          _showError(context, "No patient with this ID in this hospital.");
          return;
        }

        patientDoc = doc;
        email = patientDoc['email'];
        docId = patientInput;
      }

      final data = patientDoc.data() as Map<String, dynamic>;

      // Step 3: Check if already activated
      final alreadyActivated = data.containsKey('authId');

      // Step 4: Check if user already exists in Firebase Auth
      final methods = await auth.fetchSignInMethodsForEmail(email);

      if (methods.contains('password')) {
        if (alreadyActivated) {
          Navigator.of(context).pop();
          _showError(context, "This account is already activated. Please log in.");
          return;
        } else {
          try {
            final tempUser = await auth.signInWithEmailAndPassword(
              email: email,
              password: password,
            );

            await tempUser.user?.delete();

            final created = await auth.createUserWithEmailAndPassword(
              email: email,
              password: password,
            );

            await patientsRef.doc(docId).update({
              'authId': created.user?.uid,
              'isActivated': true,
              'activatedAt': FieldValue.serverTimestamp(),
            });

            Navigator.of(context).pop();
            Get.offAll(() => const MainNavigation());
            return;
          } catch (_) {
            Navigator.of(context).pop();
            _showError(context, "This email was already registered, but no password was set. Please contact support to reset it.");
            return;
          }
        }
      }

      // Step 5: Create user from scratch (new email)
      final created = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await patientsRef.doc(docId).update({
        'authId': created.user?.uid,
        'isActivated': true,
        'activatedAt': FieldValue.serverTimestamp(),
      });

      Navigator.of(context).pop();
      Get.offAll(() => const MainNavigation());
    } catch (e) {
      Navigator.of(context).pop();
      _showError(context, "Error: ${e.toString()}");
    }
  }

  static void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
