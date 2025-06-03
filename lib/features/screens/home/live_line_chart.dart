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

    return LineChart(
      LineChartData(
        gridData: FlGridData(show: false),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(show: false),
        minY: 0,
        maxY: dataPoints.map((e) => e.y).reduce((a, b) => a > b ? a : b) + 5,
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
                // Peak only
                if (spot == peak) {
                  return FlDotCirclePainter(
                    radius: 4,
                    color: lineColor,
                    strokeColor: Colors.black,
                    strokeWidth: 1.5,
                  );
                }

                // Return invisible painter for other points
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
