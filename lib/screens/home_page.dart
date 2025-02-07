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
                        value: glucoseProvider.currentGlucose.toString(),
                        unit: glucoseProvider.glucoseUnit,
                        time: glucoseProvider.glucoseTime,
                      ),
                      AvgGlucoseCard(
                        max: glucoseProvider.maxGlucose.toString(),
                        avg: glucoseProvider.avgGlucose.toString(),
                        min: glucoseProvider.minGlucose.toString(),
                        date: glucoseProvider.glucoseDate,
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  // ✅ Info Card with glucose data
                  InfoCard(glucoseValue: glucoseProvider.currentGlucose),
                  const SizedBox(height: 20),
                  SensorStatusCard(
                    isConnected: glucoseProvider.isConnected,
                    batteryLevel: glucoseProvider.batteryLevel,
                  ),
                  const SizedBox(height: 20),
                  HumidityTemperatureCard(
                    humidity: glucoseProvider.humidity,
                    temperature: glucoseProvider.temperature,
                  ),
                  Spacer(),
                ],
              ),
            ),
    );
  }
}
