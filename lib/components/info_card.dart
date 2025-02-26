import 'package:flutter/material.dart';

import '../utils/color_utils.dart';

class InfoCard extends StatelessWidget {
  final int glucoseValue; // Only pass the glucose value

  const InfoCard({super.key, required this.glucoseValue});

  @override
  Widget build(BuildContext context) {
    Color indicatorColor;
    String level;
    String range;
    String message;

    // Assign values based on glucose level
    if (glucoseValue < 70) {
      indicatorColor = Colors.redAccent;
      level = "Low";
      range = "< 70 mg/dL";
      message = "Eat something sweet!";
    } else if (glucoseValue <= 140) {
      indicatorColor = Colors.green;
      level = "Normal";
      range = "70 - 140 mg/dL";
      message = "Good job! Keep maintaining this level.";
    } else if (glucoseValue <= 180) {
      indicatorColor = Colors.orangeAccent;
      level = "Slightly High";
      range = "140 - 180 mg/dL";
      message = "Your glucose is rising. Stay cautious.";
    } else {
      indicatorColor = Colors.red;
      level = "Very High";
      range = "> 180 mg/dL";
      message = "Warning! Take action!";
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // ✅ Row with Indicator, Level, and Range
          Row(
            mainAxisAlignment: MainAxisAlignment.center, // Center everything
            children: [
              // ✅ Level Text (e.g., "Normal", "High")
              Text(
                level,
                style: TextStyle(
                  fontSize: 24,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w700,
                  color: primaryBlack,
                ),
              ),
              const SizedBox(width: 8),

              // ✅ Colored Circle Indicator
              Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: indicatorColor,
                  shape: BoxShape.circle,
                ),
              ),

              const SizedBox(width: 8),
              // ✅ Range Text (e.g., "70 - 140 mg/dL")
              Text(
                range,
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                  color: primaryBlack,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // ✅ Centered Grey Message
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
              color: Color(0xFF9D9B9B),
            ),
          ),
        ],
      ),
    );
  }
}
