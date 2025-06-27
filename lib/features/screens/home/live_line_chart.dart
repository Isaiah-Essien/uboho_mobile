import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class LiveLineChart extends StatelessWidget {
  final List<FlSpot> dataPoints;
  final Color lineColor;

  const LiveLineChart({
    super.key,
    required this.dataPoints,
    required this.lineColor,
  });

  @override
  Widget build(BuildContext context) {
    if (dataPoints.isEmpty) {
      return const Center(
        child: Text(
          "(Collecting...)",
          style: TextStyle(color: Colors.white24),
        ),
      );
    }

    // Find the peak point (y max)
    final FlSpot peak = dataPoints.reduce((a, b) => a.y > b.y ? a : b);

    // Determine X range: ensure line stays within bounds of the container
    final double minX = dataPoints.first.x;
    final double maxX = dataPoints.last.x;

    // Determine Y range: dynamic maxY for padding
    final double maxY = dataPoints.map((e) => e.y).reduce((a, b) => a > b ? a : b) + 5;

    return LineChart(
      LineChartData(
        gridData: FlGridData(show: false),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(show: false),
        minX: minX,
        maxX: maxX,
        minY: 0,
        maxY: maxY,
        lineBarsData: [
          LineChartBarData(
            spots: dataPoints,
            isCurved: true,
            barWidth: 2,
            color: lineColor,
            belowBarData: BarAreaData(show: false),
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                // Peak point gets a dot
                if (spot == peak) {
                  return FlDotCirclePainter(
                    radius: 4,
                    color: lineColor,
                    strokeColor: Colors.black,
                    strokeWidth: 1,
                  );
                }
                // Invisible dots for others
                return FlDotCirclePainter(
                  radius: 0,
                  color: Colors.transparent,
                  strokeWidth: 0,
                  strokeColor: Colors.transparent,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
