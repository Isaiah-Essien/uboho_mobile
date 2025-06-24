import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

class SeizureEventHandler {
  static Future<void> handleSeizureEvent() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final authId = user.uid;
      final hospitalsSnapshot = await FirebaseFirestore.instance.collection('hospitals').get();

      DocumentSnapshot? patientDoc;
      DocumentReference? patientRef;
      String hospitalId = '';
      String patientId = '';
      String adminId = '';
      String patientName = '';

      // Step 1: Identify patient and hospital
      for (final hospital in hospitalsSnapshot.docs) {
        final patients = await hospital.reference
            .collection('patients')
            .where('authId', isEqualTo: authId)
            .limit(1)
            .get();

        if (patients.docs.isNotEmpty) {
          patientDoc = patients.docs.first;
          patientRef = patientDoc.reference;
          hospitalId = hospital.id;
          patientId = patientDoc.id;
          adminId = patientDoc['createdBy'];
          patientName = patientDoc['name'] ?? '';
          break;
        }
      }

      if (patientDoc == null || patientRef == null) return;

      // Step 2: Get primary emergency contact
      final contacts = List<Map<String, dynamic>>.from(patientDoc['emergencyContacts'] ?? []);
      final primaryContact = contacts.firstWhere(
            (c) => c['isPrimary'] == true,
        orElse: () => {},
      );
      if (primaryContact.isEmpty || !(primaryContact['email']?.toString().contains('@') ?? false)) {
        print('Primary emergency contact not found or invalid.');
        return;
      }

      // Step 3: Ensure location permission is granted
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.deniedForever || permission == LocationPermission.denied) {
        print('Location permission denied.');
        return;
      }

      // Step 4: Get live location
      final position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      final latitude = position.latitude;
      final longitude = position.longitude;
      final mapsLink = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';

      // Step 5: Save seizure event to Firestore
      final eventRef = patientRef.collection('seizure_events').doc(DateTime.now().millisecondsSinceEpoch.toString());
      await eventRef.set({
        'timestamp': FieldValue.serverTimestamp(),
        'status': 'seizure',
        'location': {
          'latitude': latitude,
          'longitude': longitude,
          'mapsLink': mapsLink,
        }
      });

      // Step 6: Send mailto to emergency contact
      final email = Uri(
        scheme: 'mailto',
        path: primaryContact['email'],
        query: Uri.encodeFull(
          'subject=Seizure Alert&body=Your contact $patientName is experiencing a seizure.\n\nLive location: $mapsLink',
        ),
      );
      if (await canLaunchUrl(email)) {
        await launchUrl(email);
      } else {
        print('Could not launch email.');
      }

      // Step 7: Send automatic message to doctor
      final conversationId = '${patientId}_$adminId';
      final messageText = '🚨 Seizure alert for $patientName\nLive Location: $mapsLink';
      final timestamp = Timestamp.now();

      final messageRef = FirebaseFirestore.instance
          .collection('hospitals')
          .doc(hospitalId)
          .collection('conversations')
          .doc(conversationId)
          .collection('messages')
          .doc();

      await messageRef.set({
        'text': messageText,
        'timestamp': timestamp,
        'senderId': patientId,
        'senderName': patientName,
        'type': 'text',
      });

      final convoRef = FirebaseFirestore.instance
          .collection('hospitals')
          .doc(hospitalId)
          .collection('conversations')
          .doc(conversationId);

      await convoRef.update({
        'lastMessage': messageText,
        'lastMessageTime': timestamp,
        'unreadCount.$adminId': FieldValue.increment(1),
      });

    } catch (e) {
      print('SeizureEventHandler Error: $e');
    }
  }
}
