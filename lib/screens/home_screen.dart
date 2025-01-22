import 'dart:math';

import 'package:flutter/material.dart';

import '../utils/color_utils.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final random = Random();
    final fakeGlucoseLevel =
        (70 + random.nextDouble() * 100).toStringAsFixed(1);

    return Scaffold(
      appBar: AppBar(
        title: Text('Blood Glucose Monitor'),
        backgroundColor: primaryBlue,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Column(
              children: [
                Text(
                  'Current Glucose Level:',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(
                  '$fakeGlucoseLevel mg/dL',
                  style: TextStyle(
                      fontSize: 24,
                      color: primaryBlue,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: primaryOrange,
                  ),
                  child: Text('Refresh Data'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
