import 'dart:math';

import 'package:flutter/material.dart';

class GlucoseMeterWidget extends StatelessWidget {
  final double value; // Value in percentage (0-100)

  const GlucoseMeterWidget({Key? key, required this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        CustomPaint(
          size: Size(180, 100), // Size of the semi-circle
          painter: SemiCircularProgressPainter(value),
        ),
        Column(
          children: [
            Icon(
              Icons.water_drop, // Water drop icon
              size: 60,
              color: _getColor(value),
            ),
            SizedBox(height: 5),
            Text(
              "${value.toInt()}%",
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: _getColor(value)),
            ),
          ],
        ),
      ],
    );
  }

  Color _getColor(double value) {
    if (value < 30) {
      return Colors.red; // Low range
    } else if (value < 70) {
      return Colors.orange; // Medium range
    } else {
      return Color(0xFF3777DF); // Normal range
    }
  }
}

// Custom painter for the semi-circle progress meter
class SemiCircularProgressPainter extends CustomPainter {
  final double value;

  SemiCircularProgressPainter(this.value);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint backgroundPaint = Paint()
      ..color = Colors.grey.shade300
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round;

    final Paint progressPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round;

    final double startAngle = pi; // Start from the left side
    final double sweepAngle = pi * (value / 100); // Progress arc based on value

    // Draw background arc
    canvas.drawArc(Rect.fromLTWH(0, 0, size.width, size.height * 2), startAngle,
        pi, false, backgroundPaint);

    // Set progress color
    if (value < 30) {
      progressPaint.color = Colors.red;
    } else if (value < 70) {
      progressPaint.color = Colors.orange;
    } else {
      progressPaint.color = Color(0xFF3777DF);
    }

    // Draw progress arc
    canvas.drawArc(Rect.fromLTWH(0, 0, size.width, size.height * 2), startAngle,
        sweepAngle, false, progressPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
