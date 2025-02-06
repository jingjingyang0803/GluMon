import 'package:flutter/material.dart';
import 'package:glu_mon/utils/color_utils.dart';

class CurrentGlucoseCard extends StatelessWidget {
  final String value;
  final String unit;
  final String time;

  const CurrentGlucoseCard({
    super.key,
    required this.value,
    required this.unit,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.4,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: primaryOrange, // Dynamic color
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(Icons.water_drop, color: Colors.white),
              Column(
                crossAxisAlignment:
                    CrossAxisAlignment.end, // Align text to the right
                children: [
                  Text(
                    time.split('T')[0], // Display date (YYYY-MM-DD)
                    style: TextStyle(color: Colors.white),
                  ),
                  Text(
                    time.split('T')[1], // Display time (HH:MM:SS)
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ],
          ),
          Row(
            children: [
              Text(
                value,
                style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              SizedBox(width: 8),
              Text(unit, style: TextStyle(color: Colors.white)),
            ],
          ),
        ],
      ),
    );
  }
}
