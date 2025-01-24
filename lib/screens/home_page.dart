import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:glu_mon/components/welcome_title.dart';
import 'package:http/http.dart' as http;

import '../components/avg_glucose_card.dart';
import '../components/current_glucose_card.dart';
import '../components/info_card.dart';
import '../components/sensor_status_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // ✅ State variables for fetched data

  // Fake!!!
  String userName = "Jingjing";
  bool isConnected = false;
  int batteryLevel = 45;
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
    // _fetchData(); // ✅ Fetch data when HomePage loads
  }

  // ✅ Simulated API fetch function (Replace with real API/Firebase call)
  Future<void> _fetchData() async {
    try {
      final response =
          await http.get(Uri.parse('https://api.example.com/sensor-data'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        setState(() {
          userName = data["userName"] ?? "Unknown";
          isConnected = data["isConnected"] ?? false;
          batteryLevel = data["batteryLevel"] ?? 0;
          currentGlucose = data["currentGlucose"] ?? "--";
          glucoseTime = data["glucoseTime"] ?? "--";
          maxGlucose = data["maxGlucose"] ?? "--";
          avgGlucose = data["avgGlucose"] ?? "--";
          minGlucose = data["minGlucose"] ?? "--";
          glucoseDate = data["glucoseDate"] ?? "--";
          isLoading = false;
        });
      } else {
        print("Failed to fetch data. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching data: $e");
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
                  SizedBox(height: 20),

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
                  Spacer(),
                ],
              ),
            ),
    );
  }
}
