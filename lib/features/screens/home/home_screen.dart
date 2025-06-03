import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:uboho/utiils/constants/colors.dart';
import 'package:uboho/utiils/constants/icons.dart';
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

  @override
  void initState() {
    super.initState();

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

  @override
  void dispose() {
    accelSub?.cancel();
    gyroSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final motionPeak = motionPoints.isEmpty ? "--" : motionPoints.map((e) => e.y).reduce(max).toStringAsFixed(1);
    final rotationPeak = rotationPoints.isEmpty ? "--" : rotationPoints.map((e) => e.y).reduce(max).toStringAsFixed(1);

    return Scaffold(
      backgroundColor: UColors.backgroundColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 24), // prevents overflow at the bottom
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Purple Header with Rounded Bottom
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  height: 198,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: UColors.primaryColor,
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(12),
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Align(
                    alignment: Alignment.center,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const CircleAvatar(
                          radius: 24,
                          backgroundColor: Colors.white24,
                          backgroundImage: AssetImage('assets/images/smiley_man.jpeg'),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Mastou Oumarou",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                "PID9843084",
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(0.1),
                            border: Border.all(color: Colors.white.withOpacity(0.15)),
                          ),
                          child: const Icon(Icons.notifications, color: Colors.white, size: 18),
                        ),
                      ],
                    ),
                  ),
                ),

                // Floating Activity Info Box
                Positioned(
                  bottom: -47,
                  left: 20,
                  right: 20,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: UColors.boxHighlightColor,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: UColors.footerWithTextDividerColor),
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
                            border: Border.all(color: UColors.footerWithTextDividerColor),
                          ),
                          child: SvgPicture.asset(
                            UIcons.noteIcon,
                            fit: BoxFit.contain,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Stable",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                "Your motion intensity and rotation activity levels are normal.",
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 64), // spacing below floating box

            // Motion Intensity Card
            MetricCard(
              title: "Motion Intensity",
              description: "Your movement pattern analysis over the day.",
              dailyPeak: motionPeak,
              barChartIconPath: UIcons.motionIntensityIcon,
              lineColor: Colors.greenAccent,
              dataPoints: motionPoints,
            ),

            // Rotation Activity Card
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
