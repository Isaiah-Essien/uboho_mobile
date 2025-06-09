import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uboho/utiils/constants/colors.dart';

class PersonalInformationScreen extends StatefulWidget {
  const PersonalInformationScreen({super.key});

  @override
  State<PersonalInformationScreen> createState() => _PersonalInformationScreenState();
}

class _PersonalInformationScreenState extends State<PersonalInformationScreen> {
  String name = '';
  String email = '';
  String phone = '';
  String patientId = '';

  @override
  void initState() {
    super.initState();
    _loadPatientData();
  }

  Future<void> _loadPatientData() async {
    final authUid = FirebaseAuth.instance.currentUser?.uid;
    if (authUid == null) return;

    final hospitalsSnapshot =
    await FirebaseFirestore.instance.collection('hospitals').get();

    for (final hospitalDoc in hospitalsSnapshot.docs) {
      final patientsRef = hospitalDoc.reference.collection('patients');

      final matchQuery = await patientsRef
          .where('authId', isEqualTo: authUid)
          .limit(1)
          .get();

      if (matchQuery.docs.isNotEmpty) {
        final doc = matchQuery.docs.first;
        setState(() {
          name = doc['name'] ?? '';
          email = doc['email'] ?? '';
          phone = doc['phone'] ?? '';
          patientId = doc.id;
        });
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UColors.backgroundColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // App Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Row(
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
                      "Personal Information",
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
            ),

            // Info Card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                decoration: BoxDecoration(
                  color: UColors.boxHighlightColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    _InfoRow(label: "Name", value: name.isNotEmpty ? name : '...'),
                    const _DividerLine(),
                    _InfoRow(label: "Email", value: email.isNotEmpty ? email : '...'),
                    const _DividerLine(),
                    _InfoRow(label: "Phone Number", value: phone.isNotEmpty ? phone : '...'),
                    const _DividerLine(),
                    _InfoRow(label: "Patient ID", value: patientId.isNotEmpty ? patientId : '...'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.white70)),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

class _DividerLine extends StatelessWidget {
  const _DividerLine();

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1,
      thickness: 0.5,
      color: UColors.dividerColor.withOpacity(0.5),
    );
  }
}
