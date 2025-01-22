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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Settings')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
              title: Text('Mute Notifications'),
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
