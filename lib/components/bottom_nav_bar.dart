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

  final Color activeColor = Color(0xFF018767); // 绿色
  final Color inactiveColor = Colors.grey;

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

  /// Returns different SVG icons based on the type parameter
  Widget _buildSvgIcon(String type, Color color) {
    String svgIcon;

    if (type == "home") {
      svgIcon = '''
        <svg width="38" height="38" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
          <path d="M3 10L12 3L21 10V20H14V14H10V20H3V10Z" 
            stroke="${color.toHex()}" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
        </svg>
      ''';
    } else if (type == "stats") {
      svgIcon = '''
        <svg width="38" height="38" viewBox="0 0 29 29" fill="none" xmlns="http://www.w3.org/2000/svg">
          <path d="M10.3477 19.0896H7.32422V11.5373H10.3466V19.0908L10.3477 19.0896ZM16.3912 19.0896H13.3689V3.98145H16.3912V19.0896ZM22.4335 19.0896H19.4124V8.51377H22.4335V19.0896Z" fill="${color.toHex()}"/>
          <path fill-rule="evenodd" clip-rule="evenodd" d="M25.4558 24.7974H4.3042V22.4473H25.4558V24.7974Z" fill="${color.toHex()}"/>
        </svg>
      ''';
    } else if (type == "profile") {
      svgIcon = '''
      <svg width="38" height="38" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
        <circle cx="12" cy="8" r="4" stroke="${color.toHex()}" stroke-width="2"/>
        <path d="M4 20C4 16 8 14 12 14C16 14 20 16 20 20" stroke="${color.toHex()}" stroke-width="2" stroke-linecap="round"/>
      </svg>
    ''';
    } else {
      // Default to a placeholder SVG if type is not recognized
      svgIcon = '''
        <svg width="38" height="38" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
          <circle cx="12" cy="12" r="10" stroke="${color.toHex()}" stroke-width="2"/>
          <text x="50%" y="50%" text-anchor="middle" fill="${color.toHex()}" font-size="4" dy=".3em">?</text>
        </svg>
      ''';
    }

    return SvgPicture.string(svgIcon, width: 38, height: 38);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex], // Displays the selected page
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: bgColor,
        items: [
          BottomNavigationBarItem(
            icon: _buildSvgIcon(
                'home', _selectedIndex == 0 ? activeColor : inactiveColor),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: CustomNavButton(
              isActive: _selectedIndex == 1, // Change to false when inactive
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: _buildSvgIcon(
                'stats', _selectedIndex == 2 ? activeColor : inactiveColor),
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

Widget _buildSvgButton(bool isActive) {
  String svgButton = '''
  <svg width="60" height="60" viewBox="0 0 144 144" fill="none" xmlns="http://www.w3.org/2000/svg">
    <!-- Outer Glow when Active -->
    ${isActive ? '''
    <filter id="blurEffect">
      <feGaussianBlur in="SourceGraphic" stdDeviation="4"/>
    </filter>
    ''' : ''}

    <!-- Background Circle -->
    <circle cx="72" cy="72" r="55" fill="${isActive ? "#018767" : "#12B78F"}" 
      ${isActive ? 'filter="url(#blurEffect)"' : ''} />

    <!-- Inner Shape -->
    <path d="M72 40 L92 72 L72 104 L52 72 Z" fill="white"/>
    
    <!-- Upper Gradient -->
    <circle cx="72" cy="55" r="25" fill="url(#grad1)" />
    
    <defs>
      <linearGradient id="grad1" x1="72" y1="30" x2="72" y2="80" gradientUnits="userSpaceOnUse">
        <stop stop-color="#17d0a3"/>
        <stop offset="1" stop-color="white"/>
      </linearGradient>
    </defs>
  </svg>
  ''';

  return SvgPicture.string(
    svgButton,
    width: 60,
    height: 60,
  );
}

extension ColorExtension on Color {
  String toHex() {
    return '#${value.toRadixString(16).padLeft(8, '0').substring(2, 8).toUpperCase()}';
  }
}
