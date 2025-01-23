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
    double glucoseValue =
        double.tryParse(value) ?? 0.0; // Convert value to double

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
