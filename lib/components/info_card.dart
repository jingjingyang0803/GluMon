import 'package:flutter/material.dart';

class InfoCard extends StatelessWidget {
  final double glucoseValue; // Only pass the glucose value

  const InfoCard({super.key, required this.glucoseValue});

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    IconData icon;
    String topMessage;
    String range;
    String lowerMessage;

    // Assign values based on glucose level
    if (glucoseValue < 70) {
      bgColor = Colors.redAccent;
      icon = Icons.sentiment_dissatisfied;
      topMessage = "Low Glucose";
      range = "< 70 mg/dL";
      lowerMessage = "Eat something sweet!";
    } else if (glucoseValue <= 140) {
      bgColor = Colors.green;
      icon = Icons.sentiment_satisfied;
      topMessage = "Normal Range";
      range = "70 - 140 mg/dL";
      lowerMessage = "Good job! Keep maintaining this level.";
    } else if (glucoseValue <= 180) {
      bgColor = Colors.orangeAccent;
      icon = Icons.sentiment_neutral;
      topMessage = "Slightly High";
      range = "140 - 180 mg/dL";
      lowerMessage = "Your glucose is rising. Stay cautious.";
    } else {
      bgColor = Colors.red;
      icon = Icons.sentiment_very_dissatisfied;
      topMessage = "Very High";
      range = "> 180 mg/dL";
      lowerMessage = "Warning! Take action!";
    }

    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 30),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "$topMessage ($range)",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text(
                  lowerMessage,
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
