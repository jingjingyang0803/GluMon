import 'package:flutter/material.dart';

class GlucoseCard extends StatelessWidget {
  final String label;
  final String value;
  final String time;
  final Color color;

  const GlucoseCard({
    Key? key,
    required this.label,
    required this.value,
    required this.time,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 6),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              'mg/dL',
              style: TextStyle(
                fontSize: 14,
                color: color,
              ),
            ),
            SizedBox(height: 6),
            Text(
              'Time: $time',
              style: TextStyle(
                fontSize: 12,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
