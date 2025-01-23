import 'package:flutter/material.dart';
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
      bottomNavigationBar: BottomNavBar(),
    );
  }
}
