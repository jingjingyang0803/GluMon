import 'package:flutter/material.dart';

import '../services/database_service.dart';

class GlucoseProvider with ChangeNotifier {
  final DatabaseService _databaseService = DatabaseService();

  String currentGlucose = "165";
  String glucoseUnit = "mg/dL";
  String glucoseTime = "5 min ago";
  String maxGlucose = "180";
  String avgGlucose = "120";
  String minGlucose = "95";
  String glucoseDate = "Fri 26. Jan";
  bool isConnected = false;
  int batteryLevel = 45;
  double temperature = 36.5;
  double humidity = 55.0;
  bool isLoading = false;

  Future<void> fetchData() async {
    isLoading = true;
    notifyListeners();

    try {
      final readings = await _databaseService.getGlucoseReadings();
      final sensorStatus = await _databaseService.getDeviceStatus();

      if (readings.isNotEmpty) {
        var latestReading = readings.first;
        currentGlucose = latestReading['glucose_level'].toString();
        glucoseTime = latestReading['timestamp'];
      }

      final dailyStats = await _databaseService.getDailyMinMaxAvg();
      if (dailyStats.isNotEmpty) {
        maxGlucose = dailyStats.first['max_glucose'].toString();
        avgGlucose = dailyStats.first['avg_glucose'].toString();
        minGlucose = dailyStats.first['min_glucose'].toString();
        glucoseDate = dailyStats.first['date'];
      }

      if (sensorStatus != null) {
        isConnected = sensorStatus['connection_status'] == 'connected';
        batteryLevel = sensorStatus['battery_level'];
      }

      isLoading = false;
      notifyListeners();
    } catch (e) {
      print("❌ Error fetching data: $e");
      isLoading = false;
      notifyListeners();
    }
  }

  /// **Update Data when Sensor Sends New Readings**
  void updateSensorData(Map<String, dynamic> newData) {
    currentGlucose = newData['glucose_level'].toString();
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
