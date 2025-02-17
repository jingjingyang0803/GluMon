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

  void startListeningToBluetooth(
      Stream<String> dataStream, Stream<bool> connectionStream) {
    // 🔥 Listen for connection status updates
    connectionStream.listen((bool status) {
      isConnected = status;
      notifyListeners(); // ✅ UI updates when connection status changes
    });

    // 🔥 Listen for incoming glucose data
    dataStream.listen((data) {
      try {
        Map<String, dynamic> jsonData = jsonDecode(data);

        print("📩 Raw JSON Data Received: $jsonData");

        currentGlucose =
            (jsonData['glucose_level'] as num?)?.toInt() ?? currentGlucose;
        glucoseTime = jsonData['timestamp'] ?? "--";
        temperature =
            (jsonData['temperature'] as num?)?.toDouble() ?? temperature;
        humidity = (jsonData['humidity'] as num?)?.toDouble() ?? humidity;

        print(
            "🔄 Updated Values -> Glucose: $currentGlucose, Temp: $temperature, Humidity: $humidity");

        notifyListeners();
      } catch (e) {
        print("⚠️ Error parsing Bluetooth data: $e");
      }
    });
  }

  /// **Update Data when Sensor Sends New Readings**
  void updateSensorData(Map<String, dynamic> newData) {
    currentGlucose =
        (newData['glucose_level'] as num?)?.toInt() ?? currentGlucose;
    glucoseTime = newData['timestamp'] ?? glucoseTime;
    temperature = (newData['temperature'] as num?)?.toDouble() ?? temperature;
    humidity = (newData['humidity'] as num?)?.toDouble() ?? humidity;

    notifyListeners(); // ✅ Ensure UI refreshes
  }

  /// **Save Data to SQLite Backend**
  Future<void> saveToDatabase(Map<String, dynamic> data) async {
    await _databaseService.saveGlucoseReading(data);
    fetchData(); // Refresh data after saving
  }
}
