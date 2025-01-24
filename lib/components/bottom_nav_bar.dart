import 'package:flutter/material.dart';

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
    TrendPage(),
    SettingsPage(),
    TrendPage(),
    SettingsPage(),
  ];

  void _onItemTapped(int index) {
    if (index == 2) {
      // Handle special case for the middle button (e.g., show a modal)
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Pairing the sensor...'),
          content: Text('Almost done!'),
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
