import 'package:flutter/material.dart';

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

  Color getGlucoseColor(double glucose) {
    if (glucose < 70) {
      return Colors.redAccent; // Low glucose
    } else if (glucose >= 70 && glucose <= 140) {
      return Colors.green; // Normal range
    } else if (glucose > 140 && glucose <= 180) {
      return Colors.orangeAccent; // Slightly high
    } else {
      return Colors.red; // Very high
    }
  }

  @override
  Widget build(BuildContext context) {
    double glucoseValue =
        double.tryParse(value) ?? 0.0; // Convert value to double

    return Container(
      width: MediaQuery.of(context).size.width * 0.4,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: getGlucoseColor(glucoseValue), // Dynamic color
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(Icons.water_drop, color: Colors.white),
              Text(time, style: TextStyle(color: Colors.white)),
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
