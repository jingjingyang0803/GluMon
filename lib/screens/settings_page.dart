import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../services/database_service.dart';
import '../utils/color_utils.dart';
import '../widgets/setting_tile.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  SettingsPageState createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {
  final DatabaseService _databaseService = DatabaseService();

  bool enableVibration = false;
  bool enableCallAlert = false;
  bool enableAlarm = false;
  bool muteNotifications = true;

  int selectedInterval = 5; // Default interval
  final List<int> intervalChoices = [1, 5, 10, 15, 30, 60]; // Interval options

  TextEditingController customIntervalController = TextEditingController();

  double veryLow = 60;
  double veryHigh = 200;

  double bigDrop = 15;
  double bigRise = 25;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  /// **Fetch settings from SQLite**
  Future<void> _loadSettings() async {
    try {
      var settings = await _databaseService.getSettings();

      setState(() {
        enableVibration = settings['enableVibration'] == 1;
        enableCallAlert = settings['enableCallAlert'] == 1;
        enableAlarm = settings['enableAlarm'] == 1;
        muteNotifications = settings['muteNotifications'] == 1;
        selectedInterval = settings['selectedInterval'] ?? 5;
        veryLow = settings['veryLow'] ?? 60.0;
        veryHigh = settings['veryHigh'] ?? 200.0;
        bigDrop = settings['bigDrop'] ?? 15.0;
        bigRise = settings['bigRise'] ?? 25.0;
      });
    } catch (e) {
      print("❌ Error loading settings: $e");
    } finally {
      setState(() => isLoading = false);
    }
  }

  /// **Update settings in SQLite**
  Future<void> _updateSettings() async {
    try {
      await _databaseService.updateSettings(
        enableVibration: enableVibration,
        enableCallAlert: enableCallAlert,
        enableAlarm: enableAlarm,
        muteNotifications: muteNotifications,
        selectedInterval: selectedInterval,
        veryLow: veryLow,
        veryHigh: veryHigh,
        bigDrop: bigDrop,
        bigRise: bigRise,
      );
      print("✅ Settings updated successfully!");
    } catch (e) {
      print("❌ Error updating settings: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text('',
            style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: primaryDarkBlue)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: primaryDarkBlue),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
        child: Column(
          children: [
            _buildIntervalTile(),
            _buildAlertLimitsTile(),
            _buildAlertSettingsTile(),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildIntervalTile() {
    return SettingTile(
      title: "Data Retrieval Interval",
      subtitle: "Choose how often data is fetched",
      icon: Icons.access_time,
      children: intervalChoices.map((interval) {
        return CheckboxListTile(
          title: Text(
            "$interval minutes",
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: primaryDarkBlue,
            ),
          ),
          value: selectedInterval == interval,
          activeColor: primaryDarkBlue, // ✅ Makes the check tick BLUE
          onChanged: (bool? value) {
            if (value == true) {
              setState(() {
                selectedInterval = interval;
                _updateSettings();
              });
            }
          },
        );
      }).toList(), // ✅ FIXED: Added closing parenthesis for children list
    );
  }

  Widget _buildAlertLimitsTile() {
    return SettingTile(
      title: "Alert Limits",
      icon: Icons.warning_amber,
      children: [
        _buildSliderTile(
            "Very Low (${veryLow.toInt()} mg/dL)", veryLow, 40, 100, (val) {
          setState(() => veryLow = val);
          _updateSettings();
        }),
        _buildSliderTile(
            "Very High (${veryHigh.toInt()} mg/dL)", veryHigh, 150, 400, (val) {
          setState(() => veryHigh = val);
          _updateSettings();
        }),
        _buildSliderTile("Big Drop (${bigDrop.toInt()} mg/dL)", bigDrop, 5, 50,
            (val) {
          setState(() => bigDrop = val);
          _updateSettings();
        }),
        _buildSliderTile("Big Rise (${bigRise.toInt()} mg/dL)", bigRise, 10, 60,
            (val) {
          setState(() => bigRise = val);
          _updateSettings();
        }),
      ],
    );
  }

  Widget _buildAlertSettingsTile() {
    return SettingTile(
      title: "Alert Settings",
      icon: Icons.notifications_active_outlined,
      children: [
        _buildToggleTile("Trigger Vibration", enableVibration, (val) {
          setState(() => enableVibration = val);
          _updateSettings();
        }),
        _buildToggleTile("Trigger Phone Call Alert", enableCallAlert, (val) {
          setState(() => enableCallAlert = val);
          _updateSettings();
        }),
        _buildToggleTile("Trigger Alarm", enableAlarm, (val) {
          setState(() => enableAlarm = val);
          _updateSettings();
        }),
        _buildToggleTile("Trigger Notifications", muteNotifications, (val) {
          setState(() => muteNotifications = val);
          _updateSettings();
        }),
      ],
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
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: primaryDarkBlue)),
          GestureDetector(
            onTap: () => onChanged(!value), // Toggle on tap
            onPanUpdate: (details) {
              if (details.delta.dx > 0 && !value) {
                onChanged(true); // Drag right to turn ON
              } else if (details.delta.dx < 0 && value) {
                onChanged(false); // Drag left to turn OFF
              }
            },
            child: Container(
              decoration: BoxDecoration(
                color: value ? primaryDarkBlue : Colors.grey[300],
                borderRadius: BorderRadius.circular(20),
              ),
              width: 50,
              height: 30,
              child: Stack(
                alignment: Alignment.centerLeft,
                children: [
                  AnimatedPositioned(
                    duration: Duration(milliseconds: 200),
                    left: value ? 20 : 0,
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        border: Border.all(color: primaryDarkBlue, width: 2),
                      ),
                      child: value
                          ? Icon(Icons.check, color: primaryDarkBlue, size: 18)
                          : Container(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliderTile(String title, double value, double min, double max,
      Function(double) onChanged) {
    return Padding(
      padding: EdgeInsets.only(left: 32.0, right: 16.0, top: 8.0, bottom: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: primaryDarkBlue)),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 4.0,
              thumbShape: RoundSliderThumbShape(enabledThumbRadius: 10.0),
              overlayShape: RoundSliderOverlayShape(overlayRadius: 16.0),
              activeTrackColor: primaryDarkBlue,
              inactiveTrackColor: Colors.grey[300],
              thumbColor: primaryDarkBlue,
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
