import 'package:flutter/material.dart';
import 'package:glu_mon/screens/bluetooth_page.dart';

import '../screens/glucose_predictor_page.dart';
import '../screens/home_page.dart';
import '../screens/settings_page.dart';
import '../screens/trend_page.dart';
import '../utils/color_utils.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  BottomNavBarState createState() => BottomNavBarState();
}

class BottomNavBarState extends State<BottomNavBar> {
  int _selectedIndex = 0;

  // List of pages for navigation
  final List<Widget> _pages = [
    HomePage(),
    GlucosePredictorPage(),
    BluetoothPage(),
    TrendPage(),
    SettingsPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex], // Displays the selected page
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.home, size: 38, color: primaryBlue), label: ''),
          BottomNavigationBarItem(
              icon: Icon(Icons.water_drop, size: 38, color: primaryBlue),
              label: ''),
          BottomNavigationBarItem(
              icon: Icon(Icons.add_circle, size: 60, color: primaryBlue),
              label: ''),
          BottomNavigationBarItem(
              icon: Icon(Icons.trending_up, size: 38, color: primaryBlue),
              label: ''),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings, size: 38, color: primaryBlue),
              label: ''),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: primaryBlue,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        onTap: _onItemTapped, // Handles navigation
      ),
    );
  }
}
