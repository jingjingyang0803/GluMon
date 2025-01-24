import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils/color_utils.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  SettingsPageState createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {
  bool enableVibration = false;
  bool enableCallAlert = false;
  bool enableAlarm = false;
  bool muteNotifications = false;
  Duration muteDuration = Duration(minutes: 30);
  String selectedInterval = 'Every minute';
  TextEditingController customIntervalController = TextEditingController();

  double veryLow = 60;
  double veryHigh = 200;

  double bigDrop = 15;
  double bigRise = 25;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text('',
            style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: primaryTextColor)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: primaryTextColor),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
        child: Column(
          children: [
            _buildSettingTile(
                "Data Retrieval Interval", selectedInterval, Icons.access_time),
            _buildAlertLimitsTile(),
            _buildSettingTile("Alert Settings", "", Icons.notifications_active),
            _buildToggleTile("Trigger Vibration", enableVibration,
                (val) => setState(() => enableVibration = val)),
            _buildToggleTile("Trigger Phone Call Alert", enableCallAlert,
                (val) => setState(() => enableCallAlert = val)),
            _buildToggleTile("Trigger Alarm", enableAlarm,
                (val) => setState(() => enableAlarm = val)),
            _buildToggleTile("Disable all notifications", muteNotifications,
                (val) => setState(() => muteNotifications = val)),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildAlertLimitsTile() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Alert Limits",
                style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: primaryTextColor),
              ),
              Icon(Icons.warning, color: primaryTextColor),
            ],
          ),
          SizedBox(height: 12),
          _buildIndentedSliderTile("Very Low", veryLow, 40, 100,
              (val) => setState(() => veryLow = val)),
          _buildIndentedSliderTile("Very High", veryHigh, 150, 400,
              (val) => setState(() => veryHigh = val)),
          _buildIndentedSliderTile("Big Drop", bigDrop, 5, 50,
              (val) => setState(() => bigDrop = val)),
          _buildIndentedSliderTile("Big Rise", bigRise, 10, 60,
              (val) => setState(() => bigRise = val)),
        ],
      ),
    );
  }

  Widget _buildSettingTile(String title, String subtitle, IconData icon) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: primaryTextColor)),
              if (subtitle.isNotEmpty)
                Text(subtitle,
                    style:
                        GoogleFonts.poppins(fontSize: 14, color: Colors.grey)),
            ],
          ),
          Icon(icon, color: primaryTextColor),
        ],
      ),
    );
  }

  Widget _buildToggleTile(String title, bool value, Function(bool) onChanged) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: primaryTextColor)),
          Container(
            decoration: BoxDecoration(
              color: value ? primaryTextColor : Colors.grey[300],
              borderRadius: BorderRadius.circular(20),
            ),
            width: 50,
            height: 30,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned(
                  left: value ? 20 : 0,
                  child: GestureDetector(
                    onTap: () => onChanged(!value),
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 200),
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        border: Border.all(color: primaryTextColor, width: 2),
                      ),
                      child: value
                          ? Icon(Icons.check, color: primaryTextColor, size: 18)
                          : Container(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIndentedSliderTile(String title, double value, double min,
      double max, Function(double) onChanged) {
    return Padding(
      padding: EdgeInsets.only(left: 32.0, right: 16.0, top: 8.0, bottom: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: primaryTextColor)),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 4.0,
              thumbShape: RoundSliderThumbShape(enabledThumbRadius: 10.0),
              overlayShape: RoundSliderOverlayShape(overlayRadius: 16.0),
              activeTrackColor: primaryTextColor,
              inactiveTrackColor: Colors.grey[300],
              thumbColor: primaryTextColor,
              overlayColor: Colors.blue.withAlpha(20),
              tickMarkShape: null, // Remove tick marks
            ),
            child: Slider(
              value: value,
              min: min,
              max: max,
              label: value.toInt().toString(),
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}
