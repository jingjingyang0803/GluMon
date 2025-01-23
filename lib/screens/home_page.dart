import 'package:flutter/material.dart';
import 'package:glu_mon/components/welcome_title.dart';

import '../components/avg_glucose_card.dart';
import '../components/bottom_nav_bar.dart';
import '../components/current_glucose_card.dart';
import '../components/info_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: WelcomeTitle(name: "Jingjing"),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Text('Today',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CurrentGlucoseCard(
                    value: '225', unit: 'mg/dL', time: '2 min ago'),
                AvgGlucoseCard(
                    max: '216', avg: '116', min: '95', date: 'Wed 22. Jan'),
              ],
            ),
            SizedBox(height: 20),
            InfoCard(
              glucoseValue: 180,
            ),
            Spacer(),
            BottomNavBar(),
          ],
        ),
      ),
    );
  }
}
