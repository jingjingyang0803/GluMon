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
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 36, // Adjust spacing
        bottom: 10,
      ),
      color: bgColor, // Background color
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, // Evenly space items
        children: [
          /// **Profile Icon (Now centered properly)**
          Padding(
            padding: const EdgeInsets.only(left: 16.0), // Adjust left spacing
            child: CircleAvatar(
              radius: 35, // Bigger profile picture
              backgroundImage: AssetImage('assets/images/profile.jpg'),
            ),
          ),

          /// **Date (Centered)**
          Expanded(
            child: Center(
              child: Text(
                todayDate,
                style: TextStyle(
                  fontSize: 20, // Increased font size
                  fontWeight: FontWeight.bold,
                  color: Colors.black87, // Dark gray text
                ),
              ),
            ),
          ),

          /// **Settings Icon (Aligned properly)**
          Padding(
            padding: const EdgeInsets.only(right: 16.0), // Adjust right spacing
            child: IconButton(
              icon: SvgPicture.asset(
                'assets/icons/widget-svgrepo-com.svg',
                width: 35, // Increased size
                height: 35,
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
  Size get preferredSize => Size.fromHeight(110); // Adjusted height
}
