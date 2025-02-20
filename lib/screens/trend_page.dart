import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:glu_mon/services/database_service.dart';

import '../components/date_picker_widget.dart';
import '../components/glucose_stats_card.dart';
import '../utils/color_utils.dart';

class TrendPage extends StatefulWidget {
  const TrendPage({super.key});

  @override
  State<TrendPage> createState() => _TrendPageState();
}

class _TrendPageState extends State<TrendPage> {
  final DatabaseService _databaseService = DatabaseService();

  List<Map<String, dynamic>> glucoseData = [];
  bool isLoading = true;
  DateTime selectedDate = DateTime.now(); // Default to today

  @override
  void initState() {
    super.initState();
    _fetchDailyData(selectedDate);
  }

  /// **Fetch daily glucose data from SQLite**
  Future<void> _fetchDailyData(DateTime date) async {
    setState(() => isLoading = true);

    try {
      String dateString = "${date.year}-${date.month}-${date.day}";
      List<Map<String, dynamic>> data =
          await _databaseService.getGlucoseTrendData(dateString);

      setState(() {
        glucoseData = data;
        isLoading = false;
      });
    } catch (e) {
      print("❌ Error fetching daily glucose data: $e");
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    double minY = 0;
    double maxY = 200;

    var minEntry = glucoseData.isNotEmpty
        ? glucoseData.reduce((a, b) => a['value'] < b['value'] ? a : b)
        : null;
    var maxEntry = glucoseData.isNotEmpty
        ? glucoseData.reduce((a, b) => a['value'] > b['value'] ? a : b)
        : null;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: const Text(''),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Container(
        color: bgColor,
        padding: const EdgeInsets.all(0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              DatePickerWidget(
                onDateSelected: (date) {
                  setState(() => selectedDate = date);
                  _fetchDailyData(date);
                },
              ),
              const SizedBox(height: 16),

              // Show Loading Indicator if Data is Still Loading
              if (isLoading)
                const Center(child: CircularProgressIndicator())
              else if (glucoseData.isEmpty)
                const Center(
                    child: Text("No glucose data available for this date."))
              else
                Column(
                  children: [
                    const SizedBox(height: 16),
                    SizedBox(
                      height:
                          300, // ✅ Set a fixed height instead of using Expanded
                      child: LineChart(
                        LineChartData(
                          minY: minY,
                          maxY: maxY,
                          titlesData: FlTitlesData(
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                interval: 1,
                                getTitlesWidget: (value, meta) {
                                  int index = value.toInt();
                                  if (index >= 0 &&
                                      index < glucoseData.length) {
                                    return Padding(
                                      padding: const EdgeInsets.only(top: 4.0),
                                      child: Text(
                                        glucoseData[index]['time'],
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                    );
                                  }
                                  return const SizedBox.shrink();
                                },
                              ),
                            ),
                            leftTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: false)),
                            topTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: false)),
                            rightTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: false)),
                          ),
                          borderData: FlBorderData(show: false),
                          gridData:
                              FlGridData(show: false, drawVerticalLine: false),

                          /// Line Chart for Glucose Data with Gradient Line
                          lineBarsData: [
                            LineChartBarData(
                              spots: glucoseData.asMap().entries.map((e) {
                                return FlSpot(e.key.toDouble(),
                                    (e.value['value'] as num).toDouble());
                              }).toList(),
                              isCurved: true,
                              barWidth: 3,
                              isStrokeCapRound: true,
                              dotData: FlDotData(
                                  show: false), // This removes the dots
                              belowBarData: BarAreaData(
                                show: true,
                                gradient: LinearGradient(
                                  colors: [
                                    Color(
                                        0xFFD1E4FE), // Start color (light blue)
                                    Color(
                                        0xFFFCFDFF), // End color (light white)
                                  ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                              ),
                              color: Colors
                                  .transparent, // Make the line transparent
                              gradient: LinearGradient(
                                colors: [
                                  Color(0xFF018767), // Start color
                                  Color(0xFF02C697), // End color
                                ],
                                begin: Alignment.topLeft, // Gradient from top
                                end:
                                    Alignment.bottomRight, // Gradient to bottom
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    GlucoseStatsCard(
                      averageValue: '10',
                      minValue: maxEntry?['value'].toString() ?? "--",
                      maxValue: minEntry?['value'].toString() ?? "--",
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
