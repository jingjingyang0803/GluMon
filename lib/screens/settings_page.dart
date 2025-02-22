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
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                    top: screenHeight * 0.01), // Dynamic padding
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
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
                        text: "Glucose Unit: mg/dL",
                        iconBackgroundColor: lightGreen,
                        iconColor: primaryGreen,
                      ),
                      Divider(thickness: 1, color: bgColor),
                      SettingsMenuItem(
                        icon: Icons.notifications_active_outlined,
                        text: "Glucose Alerts: Enabled",
                        iconBackgroundColor: lightBlue,
                        iconColor: primaryBlue,
                      ),
                      Divider(thickness: 1, color: bgColor),
                      SettingsMenuItem(
                        icon: Icons.analytics_outlined,
                        text: "Trend Analysis: Active",
                        iconBackgroundColor: primaryDarkBlue,
                        iconColor: primaryBlue,
                      ),
                      Divider(thickness: 1, color: bgColor),
                      SettingsMenuItem(
                        icon: Icons.file_download_outlined,
                        text: "Export Glucose Data",
                        iconBackgroundColor: primaryOrange,
                        iconColor: Colors.white,
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
  final String Function()? trailingTextBuilder; // Callback for dynamic text

  const SettingsMenuItem({
    super.key,
    required this.icon,
    required this.text,
    required this.iconBackgroundColor,
    required this.iconColor,
    this.onTap,
    this.trailingTextBuilder,
  });

  @override
  Widget build(BuildContext context) {
    // Get screen size for dynamic adjustment
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(
            vertical: screenHeight * 0.0075), // Dynamic vertical padding
        child: Container(
          padding: EdgeInsets.symmetric(
              vertical: screenHeight * 0.008), // Dynamic vertical padding
          decoration: BoxDecoration(
            color: Colors.white, // White background for cards
            borderRadius: BorderRadius.circular(
                screenWidth * 0.03), // Dynamic rounded corners
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade200, // Light shadow
                blurRadius: 6, // Soften edges
                offset: Offset(0, 4), // Vertical shadow
              ),
            ],
          ),
          child: ListTile(
            leading: Container(
              height: screenWidth * 0.12, // Dynamic icon size
              width: screenWidth * 0.12, // Dynamic icon size
              decoration: BoxDecoration(
                color: iconBackgroundColor,
                shape: BoxShape.circle,
              ),
              child: Icon(icon,
                  color: iconColor,
                  size: screenWidth * 0.06), // Dynamic icon size
            ),
            title: Text(
              text,
              style: TextStyle(
                fontSize: screenWidth * 0.045, // Dynamic font size for text
                fontWeight: FontWeight.w500,
              ),
            ),
            trailing: trailingTextBuilder != null
                ? Text(
                    trailingTextBuilder!(),
                    style: TextStyle(
                      fontSize: screenWidth *
                          0.04, // Dynamic font size for trailing text
                      color: Colors.grey.shade600,
                    ),
                  )
                : null,
          ),
        ),
      ),
    );
  }
}
