import 'package:flutter/material.dart';

import '../utils/color_utils.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed, // Ensures full width
      backgroundColor: Colors.white, // Sets background color to white
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
        BottomNavigationBarItem(
            icon: Icon(Icons.water_drop_outlined), label: 'Measures'),
        BottomNavigationBarItem(
            icon: Icon(Icons.add_circle, size: 40), label: ''),
        BottomNavigationBarItem(
            icon: Icon(Icons.trending_up_outlined), label: 'History'),
        BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
      ],
      selectedItemColor: primaryBlue,
      unselectedItemColor: Colors.grey,
      showSelectedLabels: true,
      showUnselectedLabels: true,
    );
  }
}
