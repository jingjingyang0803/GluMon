import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:glu_mon/utils/color_utils.dart';
import 'package:intl/intl.dart';

import '../screens/settings_page.dart'; // Import settings page

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    String todayDate = DateFormat('EEE d, MMMM')
        .format(DateTime.now()); // Formats as "Fri 23, February"

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      color: bgColor, // Background color
      child: AppBar(
        backgroundColor: bgColor, // Background color
        elevation: 0, // No shadow
        toolbarHeight: 130, // Adjust height for balance
        leading: SizedBox(
          width: 85, // Increased size
          height: 85,
          child: CircleAvatar(
            radius: 50, // Bigger profile picture
            backgroundImage: AssetImage('assets/images/profile.jpg'),
          ),
        ),

        title: Text(
          todayDate, // Uses real date dynamically
          style: TextStyle(
            fontSize: 22, // Increased font size
            fontWeight: FontWeight.bold,
            color: Colors.black87, // Dark gray text
          ),
        ),

        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0, top: 8.0, bottom: 8.0),
            child: IconButton(
              icon: SvgPicture.asset(
                'assets/icons/widget-svgrepo-com.svg',
                width: 45, // Increased size
                height: 45,
                colorFilter: const ColorFilter.mode(
                    Colors.black, BlendMode.srcIn), // Adjust color dynamically
              ),
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
  Size get preferredSize => Size.fromHeight(90); // Adjusted height
}
