import 'package:flutter/material.dart';
import 'package:glu_mon/utils/color_utils.dart';
import 'package:tflite_flutter/tflite_flutter.dart' as tfl;

import '../components/circular_gauge_widget.dart';
import '../components/glucose_wave_widget.dart';

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
  }

  @override
  void dispose() {
    _interpreter.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularGaugeWidget(value: 250),
            Text(
              false ? "Measuring..." : "Device Not Connected",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: false ? lightBlue : Color(0xFFFA7E70),
              ),
            ),
            GlucoseWaveWidget(
              isConnected: false,
            ),
          ],
        ),
      ),
    );
  }
}
