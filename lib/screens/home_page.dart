import 'package:flutter/material.dart';
import 'package:glu_mon/components/welcome_title.dart';
import 'package:provider/provider.dart';

import '../components/avg_glucose_card.dart';
import '../components/current_glucose_card.dart';
import '../components/humidity_temperature_card.dart';
import '../components/info_card.dart';
import '../components/sensor_status_card.dart';
import '../providers/glucose_provider.dart';
import '../services/bluetooth_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // ✅ State variables for fetched data
  String userName = "Jingjing";

  @override
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final glucoseProvider =
          Provider.of<GlucoseProvider>(context, listen: false);
      glucoseProvider.fetchData();
      glucoseProvider.startListeningToBluetooth(
          BluetoothService().dataStream // 🔥 Connection Status Stream
          );
    });
  }

  @override
  @override
  Widget build(BuildContext context) {
    final glucoseProvider = Provider.of<GlucoseProvider>(context);

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
      body: glucoseProvider.isLoading
          ? Center(
              child: CircularProgressIndicator()) // ✅ Show loading indicator
          : (glucoseProvider.currentGlucose == null
              ? Center(
                  child: Text(
                    "Please connect to device first",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ) // ✅ Show message if no data
              : _buildMainContent(
                  glucoseProvider)), // ✅ Extract UI into a method
    );
  }

  Widget _buildMainContent(GlucoseProvider glucoseProvider) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20),
          Text(
            'Today',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: CurrentGlucoseCard(
                  value: glucoseProvider.currentGlucose?.toString() ?? "--",
                  unit: glucoseProvider.glucoseUnit ?? "mg/dL",
                  time: glucoseProvider.glucoseTime ?? "--",
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: AvgGlucoseCard(
                  max: glucoseProvider.maxGlucose?.toString() ?? "--",
                  avg: glucoseProvider.avgGlucose?.toString() ?? "--",
                  min: glucoseProvider.minGlucose?.toString() ?? "--",
                  date: glucoseProvider.glucoseDate ?? "--",
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          InfoCard(
              glucoseValue:
                  glucoseProvider.currentGlucose ?? 0), // ✅ Default to 0
          SizedBox(height: 20),
          SensorStatusCard(
            isConnected: glucoseProvider.isConnected,
            batteryLevel: glucoseProvider.batteryLevel ?? 0, // ✅ Default to 0
          ),
          SizedBox(height: 20),
          HumidityTemperatureCard(
            humidity: glucoseProvider.humidity ?? 0.0, // ✅ Default to 0.0
            temperature: glucoseProvider.temperature ?? 0.0, // ✅ Default to 0.0
          ),
          Spacer(),
        ],
      ),
    );
  }
}
