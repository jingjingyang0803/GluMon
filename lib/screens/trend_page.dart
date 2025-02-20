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
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _fetchDailyData(selectedDate);
  }

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
    DateTime now = DateTime.now();
    double currentHour =
        now.hour.toDouble() + now.minute / 60.0; // Convert to double

    var minEntry = glucoseData.isNotEmpty
        ? glucoseData.reduce((a, b) => a['value'] < b['value'] ? a : b)
        : null;
    var maxEntry = glucoseData.isNotEmpty
        ? glucoseData.reduce((a, b) => a['value'] > b['value'] ? a : b)
        : null;

    List<FlSpot> pastSpots = [];
    List<FlSpot> futureSpots = [];

    for (var entry in glucoseData) {
      double hour = double.parse(entry['time'].split(':')[0]) +
          double.parse(entry['time'].split(':')[1]) / 60.0;
      double value = (entry['value'] as num).toDouble();

      if (hour <= currentHour) {
        pastSpots.add(FlSpot(hour, value));
      } else {
        futureSpots.add(FlSpot(hour, value));
      }
    }

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
                      height: 300,
                      child: LineChart(
                        LineChartData(
                          minX: 0,
                          maxX: 24,
                          minY: minY,
                          maxY: maxY,
                          titlesData: FlTitlesData(
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                interval: 6, // Show hours at 6-hour intervals
                                getTitlesWidget: (value, meta) {
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 4.0),
                                    child: Text(
                                      "${value.toInt()}:00",
                                      style: TextStyle(
                                        color: primaryGrey,
                                        fontSize: 13,
                                        fontFamily: 'Nexa Text-Trial',
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  );
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
                          lineBarsData: [
                            // **Past Data (Darker Line)**
                            LineChartBarData(
                              spots: pastSpots,
                              isCurved: true,
                              barWidth: 3,
                              isStrokeCapRound: true,
                              dotData: FlDotData(show: false),
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
                              belowBarData: BarAreaData(
                                show: true,
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0xFFD1E4FE).withValues(
                                        alpha:
                                            0.42), // Start color (light blue)
                                    Color(
                                        0xFFFCFDFF), // End color (light white)
                                  ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                              ),
                            ),

                            // **Future Data (Lighter Line)**
                            LineChartBarData(
                              spots: futureSpots,
                              isCurved: true,
                              barWidth: 2,
                              isStrokeCapRound: true,
                              dotData: FlDotData(show: false),
                              color:
                                  const Color(0xFFCCCCCC), // Light gray color
                              belowBarData: BarAreaData(
                                show: true,
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0xFFD1E4FE).withValues(
                                        alpha:
                                            0.42), // Start color (light blue)
                                    Color(
                                        0xFFFCFDFF), // End color (light white)
                                  ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                              ),
                            ),
                          ],
                          // Update touchData to the correct property
                          lineTouchData: LineTouchData(
                            handleBuiltInTouches:
                                true, // Enable built-in touch interactions
                            touchTooltipData: LineTouchTooltipData(
                              getTooltipColor: (LineBarSpot touchedSpot) =>
                                  Colors.transparent, // Background color
                              tooltipPadding: EdgeInsets.all(
                                  8), // Padding inside the tooltip
                              tooltipMargin: 8, // Margin around the tooltip
                              maxContentWidth: 150, // Max width for the tooltip
                              tooltipRoundedRadius:
                                  4, // Rounded corners for the tooltip
                              getTooltipItems:
                                  (List<LineBarSpot> touchedSpots) {
                                return touchedSpots
                                    .map((LineBarSpot touchedSpot) {
                                  final textStyle = TextStyle(
                                    color: primaryBlack,
                                    fontFamily: 'Nexa-Trial',
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14,
                                  );
                                  return LineTooltipItem(
                                    touchedSpot.y
                                        .toString(), // The value you want to show in the tooltip
                                    textStyle,
                                  );
                                }).toList();
                              },
                            ),
                          ),
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
