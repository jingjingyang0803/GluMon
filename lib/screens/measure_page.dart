import 'package:flutter/material.dart';
import 'package:glu_mon/utils/color_utils.dart';
import 'package:provider/provider.dart';
import 'package:tflite_flutter/tflite_flutter.dart' as tfl;

import '../components/circular_gauge_widget.dart';
import '../components/custom_app_bar.dart';
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
  @override
  Widget build(BuildContext context) {
    final glucoseProvider = Provider.of<GlucoseProvider>(context);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(90),
        child: SafeArea(
          bottom: false,
          child: CustomAppBar(),
        ),
      ),
      body: SingleChildScrollView(
        child: Align(
          alignment: Alignment.center, // ✅ Ensures everything stays centered
          child: Container(
            width: MediaQuery.of(context).size.width * 0.85, // ✅ Set max width
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment:
                  CrossAxisAlignment.center, // ✅ Ensure center alignment
              children: [
                if (glucoseProvider.isConnected)
                  InfoCard(glucoseValue: glucoseProvider.currentGlucose ?? 0)
                else
                  SizedBox(height: 30),
                SizedBox(height: 10),
                CircularGaugeWidget(
                  value: glucoseProvider.isConnected
                      ? glucoseProvider.currentGlucose?.toString() ?? "--"
                      : "--",
                ),
                SizedBox(height: 20),
                Text(
                  glucoseProvider.isConnected
                      ? "Measuring glucose levels..."
                      : "No device connected. Please pair a device.",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFA7E70),
                  ),
                  textAlign: TextAlign
                      .center, // ✅ Ensures text is centered inside Column
                ),
                SizedBox(height: 10),
                GlucoseWaveWidget(
                  isConnected: glucoseProvider.isConnected,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
