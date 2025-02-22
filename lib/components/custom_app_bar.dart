import 'package:flutter/material.dart';
import 'package:glu_mon/utils/color_utils.dart';
import 'package:intl/intl.dart';

import '../screens/settings_page.dart'; // Import for formatting date

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    String todayDate = DateFormat('EEE d, MMMM')
        .format(DateTime.now()); // Formats as "Fri 23, February"

    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 30, // Add more top spacing
        bottom: 10, // Reduce bottom empty space
      ),
      color: bgColor, // Background color
      child: AppBar(
        backgroundColor: bgColor, // Background color
        elevation: 0, // No shadow
        toolbarHeight: 85, // Adjust height for balance
        leading: Padding(
          padding: const EdgeInsets.only(
              left: 16.0, top: 8.0, bottom: 8.0), // More spacing
          child: CircleAvatar(
            backgroundImage: AssetImage(
                'assets/images/profile.jpg'), // Replace with actual profile image
          ),
        ),
        title: Text(
          todayDate, // Uses real date dynamically
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87, // Dark gray text
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(
                right: 16.0, top: 8.0, bottom: 8.0), // Match left spacing
            child: IconButton(
              icon: Icon(Icons.settings_outlined,
                  color: Colors.black87), // Settings icon
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const GlucoseSettingsPage()),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(85); // Balanced height
}
