import 'package:flutter/material.dart';
import 'package:glu_mon/components/welcome_title.dart';

import '../components/avg_glucose_card.dart';
import '../components/current_glucose_card.dart';
import '../components/humidity_temperature_card.dart';
import '../components/info_card.dart';
import '../components/sensor_status_card.dart';
import '../services/database_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DatabaseService _databaseService = DatabaseService(); // SQLite Instance

  // ✅ State variables for fetched data
  String userName = "Jingjing";

  bool isConnected = false;
  int batteryLevel = 45;
  double temperature = 36.5; // Fake temperature in °C
  double humidity = 55.0; // Fake humidity in %

  String currentGlucose = "165";
  String glucoseUnit = "mg/dL";
  String glucoseTime = "5 min ago";
  String maxGlucose = "180";
  String avgGlucose = "120";
  String minGlucose = "95";
  String glucoseDate = "Fri 26. Jan";

  // bool isLoading = true;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchData(); // ✅ Fetch data from SQLite when HomePage loads
  }

  /// **Fetch Data from SQLite Database**
  Future<void> _fetchData() async {
    try {
      final readings = await _databaseService.getGlucoseReadings();
      final sensorStatus = await _databaseService.getDeviceStatus();

      if (readings.isNotEmpty) {
        setState(() {
          var latestReading = readings.first;
          currentGlucose = latestReading['glucose_level'].toString();
          glucoseTime = latestReading['timestamp']; // Assuming timestamp format
        });

        // Fetch daily min/max/avg glucose levels
        final dailyStats = await _databaseService.getDailyMinMaxAvg();
        if (dailyStats.isNotEmpty) {
          setState(() {
            maxGlucose = dailyStats.first['max_glucose'].toString();
            avgGlucose = dailyStats.first['avg_glucose'].toString();
            minGlucose = dailyStats.first['min_glucose'].toString();
            glucoseDate = dailyStats.first['date']; // Format date properly
          });
        }
      }

      if (sensorStatus != null) {
        setState(() {
          isConnected = sensorStatus['connection_status'] == 'connected';
          batteryLevel = sensorStatus['battery_level'];
        });
      }

      setState(() {
        isLoading = false; // Stop loading
      });
    } catch (e) {
      print("❌ Error fetching data from SQLite: $e");
      setState(() {
        isLoading = false; // Stop loading in case of error
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100),
        child: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          flexibleSpace: Padding(
            padding: EdgeInsets.only(top: 20, left: 16, right: 16),
            child: WelcomeTitle(name: userName),
          ),
        ),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator()) // ✅ Show loading indicator
          : Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20),
                  Text('Today',
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),

                  // ✅ Glucose Data Cards
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CurrentGlucoseCard(
                          value: currentGlucose,
                          unit: glucoseUnit,
                          time: glucoseTime),
                      AvgGlucoseCard(
                          max: maxGlucose,
                          avg: avgGlucose,
                          min: minGlucose,
                          date: glucoseDate),
                    ],
                  ),
                  SizedBox(height: 20),

                  // ✅ Info Card with glucose data
                  InfoCard(
                    glucoseValue: double.tryParse(currentGlucose) ??
                        0.0, // Convert string to double
                  ),

                  SizedBox(height: 20),

                  // ✅ Sensor Status Card
                  SensorStatusCard(
                    isConnected: isConnected,
                    batteryLevel: batteryLevel,
                  ),

                  SizedBox(height: 20),

                  // ✅ Humidity & Temperature Card
                  HumidityTemperatureCard(
                    humidity: humidity,
                    temperature: temperature,
                  ),

                  Spacer(),
                ],
              ),
            ),
    );
  }
}
