import 'package:flutter/material.dart';

import '../services/database_service.dart';

class GlucoseProvider with ChangeNotifier {
  final DatabaseService _databaseService = DatabaseService();

  int currentGlucose = 165;
  String glucoseUnit = "mg/dL";
  String glucoseTime = "5 min ago";
  int maxGlucose = 180;
  int avgGlucose = 120;
  int minGlucose = 95;
  String glucoseDate = "Fri 26. Jan";
  bool isConnected = false;
  int batteryLevel = 45;
  double temperature = 36.5;
  double humidity = 55.0;
  bool isLoading = false;

  Future<void> fetchData() async {
    print("📡 Fetching glucose data...");
    isLoading = true;
    notifyListeners();

    try {
      final readings = await _databaseService.getGlucoseReadings();
      final sensorStatus = await _databaseService.getDeviceStatus();

      if (readings.isNotEmpty) {
        var latestReading = readings.first;
        currentGlucose = (latestReading['glucose_level'] as num).toInt();
        glucoseTime = latestReading['timestamp'];
        temperature = latestReading['temperature'];
        humidity = latestReading['humidity'];
        print("✅ Data Updated: $currentGlucose at $glucoseTime");
      }

      final dailyStats = await _databaseService.getDailyMinMaxAvg();
      if (dailyStats.isNotEmpty) {
        maxGlucose = (dailyStats.first['max_glucose'] as num).toInt();
        avgGlucose = (dailyStats.first['avg_glucose'] as num).toInt();
        minGlucose = (dailyStats.first['min_glucose'] as num).toInt();
        glucoseDate = dailyStats.first['date'];
        print(
            "📊 Daily Stats Updated: Max $maxGlucose, Avg $avgGlucose, Min $minGlucose");
      }

      if (sensorStatus != null) {
        isConnected = sensorStatus['connection_status'] == 'connected';
        batteryLevel = sensorStatus['battery_level'];
        print(
            "🔋 Sensor Status: Connected: $isConnected, Battery: $batteryLevel%");
      }

      isLoading = false;
      notifyListeners(); // 🔥 Ensure UI updates
      print("🎉 UI Notified!");
    } catch (e) {
      print("❌ Error fetching data: $e");
      isLoading = false;
      notifyListeners();
    }
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
