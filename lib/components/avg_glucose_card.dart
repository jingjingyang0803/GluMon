import 'package:flutter/material.dart';

import '../utils/color_utils.dart';
import '../widgets/glucose_row.dart';

class AvgGlucoseCard extends StatelessWidget {
  final String max;
  final String avg;
  final String min;
  final String date;

  const AvgGlucoseCard({
    super.key,
    required this.max,
    required this.avg,
    required this.min,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.4,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(Icons.access_time, color: primaryBlue),
              Text(date, style: TextStyle(color: Colors.black)),
            ],
          ),
          SizedBox(height: 8),
          GlucoseRow(
            value: max,
            label: 'Max',
            color: Colors.red,
          ),
          SizedBox(height: 8),
          GlucoseRow(
            value: min,
            label: 'Min',
            color: Colors.green,
          ),
          SizedBox(height: 8),
          GlucoseRow(
            value: avg,
            label: 'Avg',
            color: primaryBlue,
          ),
        ],
      ),
    );
  }
}
