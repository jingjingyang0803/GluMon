import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:glu_mon/services/database_service.dart';
import 'package:glu_mon/utils/color_utils.dart';

import '../components/date_picker_widget.dart';
import '../components/glucose_card.dart';

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
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(''),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GlucoseCard(
                          label: 'Highest Glucose',
                          value: maxEntry?['value'].toString() ?? "--",
                          time: maxEntry?['time'] ?? "--",
                          color: Colors.red,
                        ),
                        GlucoseCard(
                          label: 'Lowest Glucose',
                          value: minEntry?['value'].toString() ?? "--",
                          time: minEntry?['time'] ?? "--",
                          color: Colors.blue,
                        ),
                      ],
                    ),
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
                              sideTitles: SideTitles(
                                  showTitles: true, reservedSize: 40),
                            ),
                            topTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: false)),
                            rightTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: false)),
                          ),
                          borderData: FlBorderData(show: false),
                          gridData:
                              FlGridData(show: false, drawVerticalLine: false),

                          /// **Colored Background for Normal/High/Low Ranges**
                          rangeAnnotations: RangeAnnotations(
                            horizontalRangeAnnotations: [
                              HorizontalRangeAnnotation(
                                  y1: minY,
                                  y2: 70,
                                  color: Colors.red.withAlpha(80)),
                              HorizontalRangeAnnotation(
                                  y1: 70,
                                  y2: 140,
                                  color: Colors.green.withAlpha(80)),
                              HorizontalRangeAnnotation(
                                  y1: 140,
                                  y2: 180,
                                  color: Colors.orange.withAlpha(80)),
                              HorizontalRangeAnnotation(
                                  y1: 180,
                                  y2: maxY,
                                  color: Colors.red.withAlpha(80)),
                            ],
                          ),

                          /// **Line Chart for Glucose Data**
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
                              color: primaryBlue,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
