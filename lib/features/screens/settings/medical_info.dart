import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uboho/utiils/constants/colors.dart';

class MedicalInformationScreen extends StatefulWidget {
  const MedicalInformationScreen({super.key});

  @override
  State<MedicalInformationScreen> createState() => _MedicalInformationScreenState();
}

class _MedicalInformationScreenState extends State<MedicalInformationScreen> {
  String height = '';
  String bloodSugar = '';
  String condition = '';
  String weight = '';
  String hospitalName = '';

  @override
  void initState() {
    super.initState();
    _loadMedicalInfo();
  }

  Future<void> _loadMedicalInfo() async {
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
          height = doc['height'] ?? '';
          bloodSugar = doc['bloodSugarLevel'] ?? '';
          condition = doc['medicalConditions'] ?? '';
          weight = doc['weight'] ?? '';
          hospitalName = doc['hospitalName'] ?? '';
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
            // App Bar with Back Icon and Title
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
                      "Medical Information",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
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
                    _InfoRow(label: "Height", value: height.isNotEmpty ? height : '...'),
                    const _DividerLine(),
                    _InfoRow(label: "Blood Sugar level", value: bloodSugar.isNotEmpty ? bloodSugar : '...'),
                    const _DividerLine(),
                    _InfoRow(label: "Medical Conditions", value: condition.isNotEmpty ? condition : '...'),
                    const _DividerLine(),
                    _InfoRow(label: "Weight", value: weight.isNotEmpty ? weight : '...'),
                    const _DividerLine(),
                    _InfoRow(label: "Hospital Name", value: hospitalName.isNotEmpty ? hospitalName : '...'),
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
