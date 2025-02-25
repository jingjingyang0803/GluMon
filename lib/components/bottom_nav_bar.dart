import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:glu_mon/screens/bluetooth_page.dart';

import '../screens/measure_page.dart';
import '../screens/trend_page.dart';
import '../utils/color_utils.dart';
import 'custom_nav_button.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  BottomNavBarState createState() => BottomNavBarState();
}

class BottomNavBarState extends State<BottomNavBar> {
  int _selectedIndex = 0;

  final Color activeColor = primaryGreen;
  final Color inactiveColor = primaryGrey;

  // List of pages for navigation
  final List<Widget> _pages = [
    MeasurePage(),
    BluetoothPage(),
    TrendPage(),
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
        backgroundColor: bgColor,
        elevation: 0, // Removes top border shadow
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/icons/home-1-svgrepo-com.svg',
              width: 35,
              height: 35,
              colorFilter: ColorFilter.mode(
                  _selectedIndex == 0
                      ? primaryGreen
                      : Colors.black, // Change color dynamically
                  BlendMode.srcIn), // Adjust color dynamically
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: CustomNavButton(
              isActive: _selectedIndex == 1, // Change to false when inactive
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/icons/diagram-up-svgrepo-com.svg',
              width: 35,
              height: 35,
              colorFilter: ColorFilter.mode(
                  _selectedIndex == 2
                      ? primaryGreen
                      : Colors.black, // Change color dynamically
                  BlendMode.srcIn), // Adjust color dynamically
            ),
            label: '',
          ),
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
