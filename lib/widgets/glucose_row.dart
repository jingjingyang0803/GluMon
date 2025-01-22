import 'package:flutter/material.dart';

class GlucoseRow extends StatelessWidget {
  final String value;
  final String label;
  final Color color;

  const GlucoseRow({
    super.key,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 50,
          child: Text(
            value,
            textAlign: TextAlign.right, // Ensures proper alignment
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ),
        SizedBox(width: 8),
        Text('$label\nmg/dL', style: TextStyle(color: Colors.black)),
      ],
    );
  }
}
