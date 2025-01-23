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
  double highBgAlert = 180;
  double lowBgAlert = 80;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Settings')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Blood Glucose Alerts',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text('High BG Alert: ${highBgAlert.toInt()} mg/dL'),
            Slider(
              value: highBgAlert,
              min: 100,
              max: 300,
              divisions: 40,
              label: highBgAlert.toInt().toString(),
              onChanged: (value) {
                setState(() {
                  highBgAlert = value;
                });
              },
            ),
            Text('Low BG Alert: ${lowBgAlert.toInt()} mg/dL'),
            Slider(
              value: lowBgAlert,
              min: 40,
              max: 100,
              divisions: 30,
              label: lowBgAlert.toInt().toString(),
              onChanged: (value) {
                setState(() {
                  lowBgAlert = value;
                });
              },
            ),
            Divider(),
            Text('Alert Settings',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SwitchListTile(
              title: Text('Trigger Vibration'),
              value: enableVibration,
              onChanged: (value) {
                setState(() {
                  enableVibration = value;
                });
              },
            ),
            SwitchListTile(
              title: Text('Trigger Phone Call Alert'),
              value: enableCallAlert,
              onChanged: (value) {
                setState(() {
                  enableCallAlert = value;
                });
              },
            ),
            SwitchListTile(
              title: Text('Trigger Alarm'),
              value: enableAlarm,
              onChanged: (value) {
                setState(() {
                  enableAlarm = value;
                });
              },
            ),
            Divider(),
            Text('Notification Settings',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SwitchListTile(
              title: Text('Disable all notifications'),
              value: muteNotifications,
              onChanged: (value) {
                setState(() {
                  muteNotifications = value;
                });
              },
            ),
            if (muteNotifications)
              DropdownButton<Duration>(
                value: muteDuration,
                onChanged: (Duration? newValue) {
                  if (newValue != null) {
                    setState(() {
                      muteDuration = newValue;
                    });
                  }
                },
                items: [
                  DropdownMenuItem(
                      value: Duration(minutes: 30), child: Text('30 minutes')),
                  DropdownMenuItem(
                      value: Duration(hours: 1), child: Text('1 hour')),
                  DropdownMenuItem(
                      value: Duration(hours: 2), child: Text('2 hours')),
                ],
              ),
            Divider(),
            Text('Data Retrieval Interval',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            DropdownButton<String>(
              value: selectedInterval,
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    selectedInterval = newValue;
                  });
                }
              },
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
            if (selectedInterval == 'Custom')
              TextField(
                controller: customIntervalController,
                keyboardType: TextInputType.number,
                decoration:
                    InputDecoration(labelText: 'Enter interval in minutes'),
              ),
          ],
        ),
      ),
    );
  }
}
