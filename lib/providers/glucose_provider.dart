import 'dart:convert';

import 'package:flutter/material.dart';

import '../services/database_service.dart';

class GlucoseProvider with ChangeNotifier {
  final DatabaseService _databaseService = DatabaseService();

  int? currentGlucose; // ✅ Change to nullable
  String glucoseUnit = "mg/dL";
  String? glucoseTime;
  int? maxGlucose;
  int? avgGlucose;
  int? minGlucose;
  String? glucoseDate;
  bool isConnected = false;
  int? batteryLevel;
  double? temperature;
  double? humidity;
  bool isLoading = false;

  Future<void> fetchData() async {
    isLoading = true;
    notifyListeners();

    try {
      final readings = await _databaseService.getGlucoseReadings();
      if (readings.isNotEmpty) {
        var latestReading = readings.first;
        currentGlucose = (latestReading['glucose_level'] as num).toInt();
        glucoseTime = latestReading['timestamp'];
        temperature = latestReading['temperature'];
        humidity = latestReading['humidity'];
      } else {
        currentGlucose = null; // ✅ No data means it's null
      }

      final dailyStats = await _databaseService.getDailyMinMaxAvg();
      if (dailyStats.isNotEmpty) {
        maxGlucose = (dailyStats.first['max_glucose'] as num).toInt();
        avgGlucose = (dailyStats.first['avg_glucose'] as num).toInt();
        minGlucose = (dailyStats.first['min_glucose'] as num).toInt();
        glucoseDate = dailyStats.first['date'];
      }

      isLoading = false;
      notifyListeners();
    } catch (e) {
      print("❌ Error fetching data: $e");
      isLoading = false;
      notifyListeners();
    }
  }

  void startListeningToBluetooth(Stream<String> dataStream) {
    dataStream.listen((data) {
      try {
        Map<String, dynamic> jsonData = jsonDecode(data);

        currentGlucose = (jsonData['glucose'] as num).toInt();
        glucoseTime = jsonData['timestamp'];
        temperature = jsonData['temp'] ?? temperature;
        humidity = jsonData['humidity'] ?? humidity;

        isConnected = jsonData['isConnected'] ?? isConnected;

        notifyListeners(); // 🔥 Notify UI of new Bluetooth data
      } catch (e) {
        print("⚠️ Error parsing Bluetooth data: $e");
      }
    });
  }

  /// **Update Data when Sensor Sends New Readings**
  void updateSensorData(Map<String, dynamic> newData) {
    currentGlucose = newData['glucose_level'];
    glucoseTime = newData['timestamp'];
    temperature = newData['temperature'] ?? temperature;
    humidity = newData['humidity'] ?? humidity;
    notifyListeners();
  }

  /// **Save Data to SQLite Backend**
  Future<void> saveToDatabase(Map<String, dynamic> data) async {
    await _databaseService.saveGlucoseReading(data);
    fetchData(); // Refresh data after saving
  }
}
