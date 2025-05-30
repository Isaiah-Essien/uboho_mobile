import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:uboho/utiils/constants/colors.dart';
import 'package:uboho/utiils/constants/icons.dart';
import 'activity_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
              dailyPeak: "76",
              barChartIconPath: UIcons.motionIntensityIcon,
              lineColor: Colors.greenAccent,
            ),

            // Rotation Activity Card
            MetricCard(
              title: "Rotation Activity",
              description: "Your rotation activity tracked by sensors.",
              dailyPeak: "38",
              barChartIconPath: UIcons.rotationIntensityIcon,
              lineColor: Colors.amberAccent,
            ),
          ],
        ),
      ),
    );
  }
}
