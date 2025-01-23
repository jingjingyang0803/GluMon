import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

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
    double minValue =
        glucoseData.map<double>((e) => e['value'].toDouble()).reduce(min);
    double maxValue =
        glucoseData.map<double>((e) => e['value'].toDouble()).reduce(max);

    var minEntry = glucoseData.firstWhere((e) => e['value'] == minValue);
    var maxEntry = glucoseData.firstWhere((e) => e['value'] == maxValue);

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
                  titlesData: FlTitlesData(show: true),
                  borderData: FlBorderData(show: false),
                  gridData: FlGridData(show: true, drawVerticalLine: false),

                  /// ✅ **Fixed Background Sections using `rangeAnnotations`**
                  rangeAnnotations: RangeAnnotations(
                    horizontalRangeAnnotations: [
                      HorizontalRangeAnnotation(
                        y1: 0,
                        y2: 70,
                        color: Colors.red.withOpacity(0.2),
                      ),
                      HorizontalRangeAnnotation(
                        y1: 70,
                        y2: 140,
                        color: Colors.green.withOpacity(0.2),
                      ),
                      HorizontalRangeAnnotation(
                        y1: 140,
                        y2: 180,
                        color: Colors.orange.withOpacity(0.2),
                      ),
                      HorizontalRangeAnnotation(
                        y1: 180,
                        y2: 250,
                        color: Colors.red.withOpacity(0.2),
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
                      color: Colors.blue,
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
