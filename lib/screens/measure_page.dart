import 'package:flutter/material.dart';
import 'package:glu_mon/utils/color_utils.dart';
import 'package:provider/provider.dart';
import 'package:tflite_flutter/tflite_flutter.dart' as tfl;

import '../components/circular_gauge_widget.dart';
import '../components/glucose_wave_widget.dart';
import '../components/info_card.dart';
import '../providers/glucose_provider.dart';
import '../services/bluetooth_service.dart';

class MeasurePage extends StatefulWidget {
  const MeasurePage({super.key});

  @override
  MeasurePageState createState() => MeasurePageState();
}

class MeasurePageState extends State<MeasurePage> {
  late tfl.Interpreter _interpreter;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final glucoseProvider =
          Provider.of<GlucoseProvider>(context, listen: false);
      final bluetoothService = BluetoothService();

      glucoseProvider.fetchData();
      glucoseProvider.startListeningToBluetooth(
        bluetoothService.dataStream, // 🔥 Pass the Data Stream
        bluetoothService
            .connectionStatusStream, // 🔥 Pass the Connection Status Stream
      );
    });
  }

  @override
  void dispose() {
    _interpreter.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final glucoseProvider = Provider.of<GlucoseProvider>(context);

    return Scaffold(
      backgroundColor: bgColor,
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularGaugeWidget(
                value: glucoseProvider.currentGlucose?.toString() ?? "--"),
            SizedBox(height: 10),
            Text(
              glucoseProvider.isConnected
                  ? "Measuring..."
                  : "Device Not Connected",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color:
                    glucoseProvider.isConnected ? lightBlue : Color(0xFFFA7E70),
              ),
            ),
            GlucoseWaveWidget(
              isConnected: glucoseProvider.isConnected,
            ),
            SizedBox(height: 10),
            InfoCard(glucoseValue: glucoseProvider.currentGlucose ?? 0),
          ],
        ),
      ),
    );
  }
}
