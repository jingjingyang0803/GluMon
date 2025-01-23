import 'package:flutter/material.dart';

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
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Settings', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle("DATA RETRIEVAL INTERVAL"),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: DropdownButtonFormField<String>(
                value: selectedInterval,
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() => selectedInterval = newValue);
                  }
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                items: [
                  DropdownMenuItem(
                      value: 'Every minute', child: Text('Every minute')),
                  DropdownMenuItem(
                      value: 'Every five minutes',
                      child: Text('Every five minutes')),
                  DropdownMenuItem(
                      value: 'Custom', child: Text('Custom Interval')),
                ],
              ),
            ),
            if (selectedInterval == 'Custom')
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: TextField(
                  controller: customIntervalController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Enter interval in minutes',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ),
            _buildSectionTitle("ALERT LIMITS"),
            _buildSliderRow("Very Low", veryLow, 40, 100,
                (value) => setState(() => veryLow = value)),
            _buildSliderRow("Very High", veryHigh, 150, 400,
                (value) => setState(() => veryHigh = value)),
            _buildSectionTitle("QUICK CHANGES"),
            _buildSliderRow("Big Drop", bigDrop, 5, 50,
                (value) => setState(() => bigDrop = value)),
            _buildSliderRow("Big Rise", bigRise, 10, 60,
                (value) => setState(() => bigRise = value)),
            _buildSectionTitle("ALERT SETTINGS"),
            _buildSwitchTile("Trigger Vibration", enableVibration,
                (value) => setState(() => enableVibration = value)),
            _buildSwitchTile("Trigger Phone Call Alert", enableCallAlert,
                (value) => setState(() => enableCallAlert = value)),
            _buildSwitchTile("Trigger Alarm", enableAlarm,
                (value) => setState(() => enableAlarm = value)),
            _buildSectionTitle("NOTIFICATION SETTINGS"),
            _buildSwitchTile("Disable all notifications", muteNotifications,
                (value) => setState(() => muteNotifications = value)),
            if (muteNotifications)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: DropdownButtonFormField<Duration>(
                  value: muteDuration,
                  onChanged: (Duration? newValue) {
                    if (newValue != null) {
                      setState(() => muteDuration = newValue);
                    }
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  items: [
                    DropdownMenuItem(
                        value: Duration(minutes: 30),
                        child: Text('30 minutes')),
                    DropdownMenuItem(
                        value: Duration(hours: 1), child: Text('1 hour')),
                    DropdownMenuItem(
                        value: Duration(hours: 2), child: Text('2 hours')),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
            fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey),
      ),
    );
  }

  Widget _buildSliderRow(String title, double value, double min, double max,
      Function(double) onChanged) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 2,
            child: Text(title, style: TextStyle(fontSize: 16)),
          ),
          Expanded(
            flex: 5,
            child: Slider(
              value: value,
              min: min,
              max: max,
              divisions: ((max - min) / 5).toInt(),
              label: value.toInt().toString(),
              onChanged: onChanged,
            ),
          ),
          SizedBox(width: 10),
          Text(value.toInt().toString(), style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildSwitchTile(String title, bool value, Function(bool) onChanged) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 0, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(fontSize: 16)),
          Switch(value: value, onChanged: onChanged),
        ],
      ),
    );
  }
}
