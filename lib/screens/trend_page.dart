import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class TrendPage extends StatelessWidget {
  final List<Map<String, dynamic>> glucoseData = [
    {'time': '08:00', 'value': 90},
    {'time': '10:00', 'value': 120},
    {'time': '12:00', 'value': 140},
    {'time': '14:00', 'value': 110},
    {'time': '16:00', 'value': 85},
    {'time': '18:00', 'value': 100},
    {'time': '20:00', 'value': 130},
  ];

  TrendPage({super.key});

  @override
  Widget build(BuildContext context) {
    double minValue = glucoseData
        .map<double>((e) => (e['value'] as num)
            .toDouble()) // Explicitly cast to num then double
        .reduce(min);

    double maxValue = glucoseData
        .map<double>((e) => (e['value'] as num)
            .toDouble()) // Explicitly cast to num then double
        .reduce(max);

    var minEntry = glucoseData.firstWhere((e) => e['value'] == minValue);
    var maxEntry = glucoseData.firstWhere((e) => e['value'] == maxValue);

    return Scaffold(
      appBar: AppBar(title: Text('Glucose Trend')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Glucose Levels Today',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            Expanded(
              child: LineChart(
                LineChartData(
                  titlesData: FlTitlesData(show: false),
                  borderData: FlBorderData(show: false),
                  gridData: FlGridData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: glucoseData
                          .asMap()
                          .entries
                          .map((e) => FlSpot(
                              e.key.toDouble(), e.value['value'].toDouble()))
                          .toList(),
                      isCurved: true,
                      color: Colors.red,
                      barWidth: 3,
                      isStrokeCapRound: true,
                      belowBarData: BarAreaData(
                          show: true, color: Colors.red.withValues(alpha: 0.5)),
                      dotData: FlDotData(show: true),
                    )
                  ],
                  extraLinesData: ExtraLinesData(horizontalLines: [
                    HorizontalLine(
                        y: maxValue,
                        color: Colors.red,
                        strokeWidth: 2,
                        dashArray: [5, 5]),
                    HorizontalLine(
                        y: minValue,
                        color: Colors.blue,
                        strokeWidth: 2,
                        dashArray: [5, 5]),
                  ]),
                ),
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Text('Max: ${maxEntry['value']} mg/dL',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.red)),
                    Text('Time: ${maxEntry['time']}'),
                  ],
                ),
                Column(
                  children: [
                    Text('Min: ${minEntry['value']} mg/dL',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue)),
                    Text('Time: ${minEntry['time']}'),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
