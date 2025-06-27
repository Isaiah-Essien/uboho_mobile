import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:uboho/utiils/constants/colors.dart';
import 'package:uboho/utiils/constants/icons.dart';

import 'live_line_chart.dart';

class MetricCard extends StatefulWidget {
  final String title;
  final String description;
  final String barChartIconPath;
  final String dailyPeak;
  final Color lineColor;
  final List<FlSpot> dataPoints;

  const MetricCard({
    super.key,
    required this.title,
    required this.description,
    required this.barChartIconPath,
    required this.dailyPeak,
    required this.lineColor,
    required this.dataPoints,
  });

  @override
  State<MetricCard> createState() => _MetricCardState();
}

class _MetricCardState extends State<MetricCard> {
  String selectedRange = 'Day';
  final List<String> options = ['Day', 'Week', 'Month', 'Year'];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: UColors.boxHighlightColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4.72),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.8),
                    width: 0.3,
                  ),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: selectedRange,
                    dropdownColor: UColors.backgroundColor,
                    isDense: true,
                    icon: Padding(
                      padding: const EdgeInsets.only(left: 4),
                      child: SvgPicture.asset(
                        UIcons.dropdownIcon,
                        width: 6.87,
                        height: 3.95,
                        fit: BoxFit.contain,
                      ),
                    ),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                    onChanged: (value) {
                      setState(() => selectedRange = value!);
                    },
                    items: options
                        .map((option) => DropdownMenuItem(
                      value: option,
                      child: Text(option),
                    ))
                        .toList(),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          Text(
            widget.description,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 12,
            ),
          ),

          const SizedBox(height: 12),

          // Chart Container with Clipping
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Container(
              height: 100,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [widget.lineColor.withOpacity(0.2), Colors.transparent],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
              child: widget.dataPoints.isEmpty
                  ? const Center(
                child: Text(
                  "(Collecting...)",
                  style: TextStyle(color: Colors.white24),
                ),
              )
                  : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: LiveLineChart(
                  dataPoints: widget.dataPoints,
                  lineColor: widget.lineColor,
                ),
              ),
            ),
          ),

          const SizedBox(height: 12),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Daily Peak",
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    widget.dailyPeak,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              SvgPicture.asset(
                widget.barChartIconPath,
                height: 24,
                width: 24,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
