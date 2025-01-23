import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:glu_mon/utils/color_utils.dart';

class TrendPage extends StatelessWidget {
  final List<Map<String, dynamic>> glucoseData = [
    {'time': '08:00', 'value': 90},
    {'time': '10:00', 'value': 120},
    {'time': '12:00', 'value': 160},
    {'time': '14:00', 'value': 110},
    {'time': '16:00', 'value': 85},
    {'time': '18:00', 'value': 100},
    {'time': '20:00', 'value': 190},
  ];

  TrendPage({super.key});

  @override
  Widget build(BuildContext context) {
    double minY = 50; // 🔹 Set fixed Y min
    double maxY = 200; // 🔹 Set fixed Y max

    var minEntry =
        glucoseData.reduce((a, b) => a['value'] < b['value'] ? a : b);
    var maxEntry =
        glucoseData.reduce((a, b) => a['value'] > b['value'] ? a : b);

    return Scaffold(
      appBar: AppBar(title: const Text('Glucose Trend')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text('Glucose Levels Today',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Text('Max: ${maxEntry['value']} mg/dL',
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.red)),
                    Text('Time: ${maxEntry['time']}'),
                  ],
                ),
                Column(
                  children: [
                    Text('Min: ${minEntry['value']} mg/dL',
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue)),
                    Text('Time: ${minEntry['time']}'),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: LineChart(
                LineChartData(
                  minY: minY, // 🔹 Set fixed min Y
                  maxY: maxY, // 🔹 Set fixed max Y

                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval:
                            1, // 🔹 Ensure labels only appear at defined spots
                        getTitlesWidget: (value, meta) {
                          int index = value.toInt();
                          if (index >= 0 && index < glucoseData.length) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 4.0),
                              child: Text(
                                glucoseData[index]
                                    ['time'], // ✅ Show actual time values
                                style: const TextStyle(fontSize: 12),
                              ),
                            );
                          }
                          return const SizedBox
                              .shrink(); // 🔹 Hide unnecessary labels
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize:
                            40, // 🔹 Increase space for left Y-axis labels
                      ),
                    ),
                    topTitles: AxisTitles(
                      // 🔹 Hide top labels
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: AxisTitles(
                      // 🔹 Hide right labels if needed
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  gridData: FlGridData(show: true, drawVerticalLine: false),

                  /// ✅ **Fixed Background Sections**
                  rangeAnnotations: RangeAnnotations(
                    horizontalRangeAnnotations: [
                      HorizontalRangeAnnotation(
                        y1: minY, // 🔹 Start at the fixed min Y
                        y2: 70,
                        color: Colors.red,
                      ),
                      HorizontalRangeAnnotation(
                        y1: 70,
                        y2: 140,
                        color: Colors.green,
                      ),
                      HorizontalRangeAnnotation(
                        y1: 140,
                        y2: 180,
                        color: Colors.orangeAccent,
                      ),
                      HorizontalRangeAnnotation(
                        y1: 180,
                        y2: maxY, // 🔹 End at the fixed max Y
                        color: Colors.red,
                      ),
                    ],
                  ),

                  /// 📈 **Line Chart for Glucose Data**
                  lineBarsData: [
                    LineChartBarData(
                      spots: glucoseData.asMap().entries.map((e) {
                        return FlSpot(e.key.toDouble(),
                            (e.value['value'] as num).toDouble());
                      }).toList(),
                      isCurved: true,
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: FlDotData(show: true),
                      belowBarData: BarAreaData(show: false),
                      color: primaryOrange,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
