// HomeScreen.dart

import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:uboho/features/screens/notification_center/notification_screen.dart';
import 'package:uboho/utiils/constants/colors.dart';
import 'package:uboho/utiils/constants/icons.dart';
import '../../../service_backend/settiings_logics/profile_picture_service.dart';
import 'activity_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<FlSpot> motionPoints = [];
  List<FlSpot> rotationPoints = [];
  int timeIndex = 0;

  double ax = 0, ay = 0, az = 0;
  double gx = 0, gy = 0, gz = 0;

  StreamSubscription? accelSub;
  StreamSubscription? gyroSub;
  Timer? firestoreTimer;

  String patientName = '';
  String patientId = '';
  String? profileImageUrl;

  final ProfileImageService _imageService = ProfileImageService();

  @override
  void initState() {
    super.initState();
    _fetchPatientDetails();
    _loadProfileImage();

    accelSub = accelerometerEventStream().listen((event) {
      ax = event.x;
      ay = event.y;
      az = event.z;
      _processMotion();
    });

    gyroSub = gyroscopeEventStream().listen((event) {
      gx = event.x;
      gy = event.y;
      gz = event.z;
      _processRotation();
    });

    firestoreTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      _uploadSensorDataToFirestore();
    });
  }

  Future<void> _fetchPatientDetails() async {
    final authUid = FirebaseAuth.instance.currentUser?.uid;
    if (authUid == null) return;

    final hospitalsSnapshot =
    await FirebaseFirestore.instance.collection('hospitals').get();
    for (final hospitalDoc in hospitalsSnapshot.docs) {
      final patientsRef = hospitalDoc.reference.collection('patients');
      final matchQuery =
      await patientsRef.where('authId', isEqualTo: authUid).limit(1).get();

      if (matchQuery.docs.isNotEmpty) {
        final doc = matchQuery.docs.first;
        setState(() {
          patientName = doc['name'] ?? '';
          patientId = doc.id;
        });
        break;
      }
    }
  }

  Future<void> _loadProfileImage() async {
    final url = await _imageService.fetchProfileImageUrl();
    if (url != null) {
      setState(() {
        profileImageUrl = url;
      });
    }
  }

  void _processMotion() {
    final motion = sqrt(ax * ax + ay * ay + az * az);
    setState(() {
      motionPoints.add(FlSpot(timeIndex.toDouble(), motion));
      if (motionPoints.length > 50) motionPoints.removeAt(0);
    });
  }

  void _processRotation() {
    final rotation = sqrt(gx * gx + gy * gy + gz * gz);
    setState(() {
      rotationPoints.add(FlSpot(timeIndex.toDouble(), rotation));
      if (rotationPoints.length > 50) rotationPoints.removeAt(0);
      timeIndex++;
    });
  }

  void _uploadSensorDataToFirestore() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null || patientId.isEmpty) return;

    final hospitalsSnapshot =
    await FirebaseFirestore.instance.collection('hospitals').get();
    for (final hospitalDoc in hospitalsSnapshot.docs) {
      final patientsRef = hospitalDoc.reference.collection('patients');
      final matchQuery =
      await patientsRef.where('authId', isEqualTo: uid).limit(1).get();

      if (matchQuery.docs.isNotEmpty) {
        final patientDocRef = matchQuery.docs.first.reference;

        final sensorData = {
          'x_accel': ax,
          'y_accel': ay,
          'z_accel': az,
          'x_gyro': gx,
          'y_gyro': gy,
          'z_gyro': gz,
          'timestamp': DateTime.now().millisecondsSinceEpoch,
        };

        try {
          await patientDocRef.collection('sensors').doc('current').set(sensorData);
        } catch (e) {
          debugPrint("Error uploading sensor data: $e");
        }

        break;
      }
    }
  }

  @override
  void dispose() {
    accelSub?.cancel();
    gyroSub?.cancel();
    firestoreTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final motionPeakValue =
    motionPoints.isEmpty ? 0 : motionPoints.map((e) => e.y).reduce(max);
    final rotationPeakValue =
    rotationPoints.isEmpty ? 0 : rotationPoints.map((e) => e.y).reduce(max);

    final motionPeak = motionPeakValue.toStringAsFixed(1);
    final rotationPeak = rotationPeakValue.toStringAsFixed(1);

    final isUnstable = motionPeakValue >= 20 && rotationPeakValue >= 3;

    return Scaffold(
      backgroundColor: UColors.backgroundColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  height: 198,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: UColors.primaryColor,
                    borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(12)),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Align(
                    alignment: Alignment.center,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 24,
                          backgroundColor: Colors.white24,
                          backgroundImage: profileImageUrl != null
                              ? CachedNetworkImageProvider(profileImageUrl!)
                              : null,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                patientName.isEmpty ? "..." : patientName,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                patientId.isEmpty ? "" : patientId,
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => NotificationCenterScreen()),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withOpacity(0.1),
                              border: Border.all(
                                  color: Colors.white.withOpacity(0.15)),
                            ),
                            child: const Icon(Icons.notifications,
                                color: Colors.white, size: 18),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: -47,
                  left: 20,
                  right: 20,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: UColors.boxHighlightColor,
                      borderRadius: BorderRadius.circular(20),
                      border:
                      Border.all(color: UColors.footerWithTextDividerColor),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 54,
                          height: 54,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: UColors.backgroundColor,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                                color: UColors.footerWithTextDividerColor),
                          ),
                          child: SvgPicture.asset(
                            UIcons.noteIcon,
                            color: isUnstable ? Colors.redAccent : UColors.primaryColor,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                isUnstable ? "Unstable" : "Stable",
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                isUnstable
                                    ? "Unusual motion and rotation patterns detected."
                                    : "Your motion intensity and rotation activity levels are normal.",
                                style: const TextStyle(
                                    color: Colors.white70, fontSize: 12),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(height: 64),
            MetricCard(
              title: "Motion Intensity",
              description: "Your movement pattern analysis over the day.",
              dailyPeak: motionPeak,
              barChartIconPath: UIcons.motionIntensityIcon,
              lineColor: Colors.greenAccent,
              dataPoints: motionPoints,
            ),
            MetricCard(
              title: "Rotation Activity",
              description: "Your rotation activity tracked by sensors.",
              dailyPeak: rotationPeak,
              barChartIconPath: UIcons.rotationIntensityIcon,
              lineColor: Colors.amberAccent,
              dataPoints: rotationPoints,
            ),
          ],
        ),
      ),
    );
  }
}
