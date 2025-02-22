import 'package:flutter/material.dart';

import '../components/logout_popup.dart';
import '../utils/color_utils.dart';

class GlucoseSettingsPage extends StatelessWidget {
  static const String id = 'glucose_settings_page';

  const GlucoseSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Get screen size
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        iconTheme: IconThemeData(color: primaryBlack),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔹 Profile Section (Static)
            Row(
              children: [
                Container(
                  width: screenWidth *
                      0.2, // Adjust size dynamically based on screen width
                  height: screenWidth *
                      0.2, // Adjust size dynamically based on screen width
                  padding: EdgeInsets.all(screenWidth *
                      0.01), // Dynamic padding based on screen size
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: lightGreen,
                        width: screenWidth * 0.005), // Dynamic border width
                  ),
                  child: CircleAvatar(
                    radius: 40,
                    backgroundColor: primaryGrey,
                    backgroundImage: AssetImage('assets/images/profile.jpg'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "user@example.com", // Replace with actual email
                        style: TextStyle(color: primaryGrey, fontSize: 16),
                      ),
                      Text(
                        "Your Name",
                        style: TextStyle(
                          color: primaryBlack,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // 🔹 Settings List (Non-Interactive)
            SizedBox(
              height: screenHeight * 0.65, // ✅ Adjust height dynamically
              child: Padding(
                padding: EdgeInsets.only(
                    top: screenHeight * 0.01), // Dynamic padding
                child: Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14), // ✅ Adds space inside container
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(35),
                    boxShadow: [
                      BoxShadow(
                        color: primaryGrey.withOpacity(0.2),
                        blurRadius: 10,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      SettingsMenuItem(
                        icon: Icons.timeline,
                        text: "Glucose Unit",
                        iconBackgroundColor: lightGreen,
                        iconColor: primaryGreen,
                        trailingTextBuilder: () => "mg/dL", // pass text
                      ),
                      Divider(thickness: 1, color: bgColor),
                      SettingsMenuItem(
                        icon: Icons.notifications_active_outlined,
                        text: "Glucose Alerts",
                        iconBackgroundColor: lightGreen,
                        iconColor: primaryGreen,
                      ),
                      Divider(thickness: 1, color: bgColor),
                      SettingsMenuItem(
                        icon: Icons.analytics_outlined,
                        text: "Trend Analysis",
                        iconBackgroundColor: lightGreen,
                        iconColor: primaryGreen,
                      ),
                      Divider(thickness: 1, color: bgColor),
                      SettingsMenuItem(
                        icon: Icons.file_download_outlined,
                        text: "Export Data",
                        iconBackgroundColor: lightGreen,
                        iconColor: primaryGreen,
                      ),
                      Divider(thickness: 1, color: bgColor),
                      SettingsMenuItem(
                        icon: Icons.logout,
                        text: "Logout",
                        iconBackgroundColor: primaryOrange,
                        iconColor: Colors.white,
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            backgroundColor: Colors.transparent,
                            isScrollControlled: true,
                            builder: (BuildContext context) {
                              return LogoutPopup(
                                onConfirm: () {
                                  Navigator.of(context).pop();
                                },
                                onCancel: () {
                                  Navigator.of(context).pop();
                                },
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 🔹 Single Row Widget for Each Setting
class SettingsMenuItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color iconBackgroundColor;
  final Color iconColor;
  final VoidCallback? onTap;
  final String Function()? trailingTextBuilder;
  final IconData? trailingIcon; // Optional trailing icon

  const SettingsMenuItem({
    super.key,
    required this.icon,
    required this.text,
    required this.iconBackgroundColor,
    required this.iconColor,
    this.onTap,
    this.trailingTextBuilder,
    this.trailingIcon,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(
            vertical: screenHeight * 0.0025), // Vertical spacing
        child: Container(
          padding: EdgeInsets.symmetric(
              vertical: screenHeight * 0.015, horizontal: 16), // Inner padding
          decoration: BoxDecoration(
            color: Colors.white, // Background color
            borderRadius:
                BorderRadius.circular(screenWidth * 0.25), // Rounded corners
            border: Border.all(
              color: lightGreen.withOpacity(0.3), // ✅ Light blurred border
              width: 2, // ✅ Thin border
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // ✅ Icon + Text
              Row(
                children: [
                  Container(
                    height: screenWidth * 0.12,
                    width: screenWidth * 0.12,
                    decoration: BoxDecoration(
                      color: iconBackgroundColor,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      icon,
                      color: iconColor,
                      size: screenWidth * 0.06,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    text,
                    style: TextStyle(
                      fontSize: screenWidth * 0.045,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),

              // ✅ Trailing Text / Icon
              Row(
                children: [
                  if (trailingTextBuilder != null)
                    Text(
                      trailingTextBuilder!(),
                      style: TextStyle(
                        fontSize: screenWidth * 0.04,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  if (trailingIcon != null) ...[
                    const SizedBox(width: 8),
                    Icon(
                      trailingIcon,
                      color: Colors.grey.shade600,
                      size: screenWidth * 0.05,
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
