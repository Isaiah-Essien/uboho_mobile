import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';

class ProfileImageService {
  final ImagePicker _picker = ImagePicker();

  // Function to pick, upload image and store the download URL in Firestore
  Future<XFile?> pickAndUploadImage({
    required BuildContext context,
    required Function(String url) onUploadComplete,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return null;

    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 70, // compress to reduce cost
      );

      if (pickedFile == null) return null;

      // Upload to Firebase Storage
      final storageRef = FirebaseStorage.instance
          .ref()
          .child("profile_images/${user.uid}");
      await storageRef.putFile(File(pickedFile.path));

      // Get download URL
      final downloadUrl = await storageRef.getDownloadURL();

      // Update Firestore (search through hospitals > patients)
      final hospitals = await FirebaseFirestore.instance
          .collection('hospitals')
          .get();

      for (final hospitalDoc in hospitals.docs) {
        final patientsRef = hospitalDoc.reference.collection('patients');
        final matchQuery = await patientsRef
            .where('authId', isEqualTo: user.uid)
            .limit(1)
            .get();

        if (matchQuery.docs.isNotEmpty) {
          await patientsRef.doc(matchQuery.docs.first.id).update({
            'profileImageUrl': downloadUrl,
          });
          break;
        }
      }

      // Return the result
      onUploadComplete(downloadUrl);
      return pickedFile;
    } catch (e) {
      debugPrint('Profile image upload failed: $e');
      return null;
    }
  }

  // Function to fetch the image URL of the currently logged-in user
  Future<String?> fetchProfileImageUrl() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return null;

    final hospitals = await FirebaseFirestore.instance.collection('hospitals').get();

    for (final hospitalDoc in hospitals.docs) {
      final patientsRef = hospitalDoc.reference.collection('patients');
      final matchQuery = await patientsRef
          .where('authId', isEqualTo: uid)
          .limit(1)
          .get();

      if (matchQuery.docs.isNotEmpty) {
        return matchQuery.docs.first['profileImageUrl'];
      }
    }

    return null;
  }
}
