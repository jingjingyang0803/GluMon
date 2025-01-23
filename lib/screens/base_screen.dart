import 'package:flutter/material.dart';
import 'package:glu_mon/screens/settings_page.dart';
import 'package:glu_mon/screens/trend_page.dart';

import '../utils/color_utils.dart';
import 'home_page.dart';

class BaseScreen extends StatefulWidget {
  const BaseScreen({super.key});

  @override
  BaseScreenState createState() => BaseScreenState();
}

class BaseScreenState extends State<BaseScreen> {
  int _selectedIndex = 0; // Default page index (HomeScreen)

  // List of pages for navigation
  final List<Widget> _pages = [
    HomePage(),
    Placeholder(),
    Placeholder(),
    TrendPage(),
    SettingsPage(),
  ];

  void _onItemTapped(int index) {
    if (index == 2) {
      // Special case for the middle button (e.g., open a modal)
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Add Measurement'),
          content: Text('Navigate to add new measurement.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Close'),
            ),
          ],
        ),
      );
      return;
    }

    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex], // Display selected page
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.water_drop_outlined), label: 'Measures'),
          BottomNavigationBarItem(
              icon: Icon(Icons.add_circle, size: 40), label: ''),
          BottomNavigationBarItem(
              icon: Icon(Icons.trending_up_outlined), label: 'History'),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: 'Settings'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: primaryBlue,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        onTap: _onItemTapped,
      ),
    );
  }
}
