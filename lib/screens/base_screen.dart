import 'package:flutter/material.dart';
import 'package:glu_mon/screens/bluetooth_page.dart';
import 'package:glu_mon/screens/glucose_predictor_page.dart';
import 'package:glu_mon/screens/settings_page.dart';
import 'package:glu_mon/screens/trend_page.dart';

import '../components/bottom_nav_bar.dart';
import 'home_page.dart';

class BaseScreen extends StatefulWidget {
  const BaseScreen({super.key});

  @override
  BaseScreenState createState() => BaseScreenState();
}

class BaseScreenState extends State<BaseScreen> {
  final int _selectedIndex = 0; // Default page index (HomeScreen)

  // List of pages for navigation
  final List<Widget> _pages = [
    HomePage(),
    GlucosePredictorPage(),
    BluetoothPage(),
    TrendPage(),
    SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex], // Display selected page
      bottomNavigationBar: BottomNavBar(),
    );
  }
}
