import 'dart:math';

import 'package:flutter/material.dart';

class CircularGaugeWidget extends StatelessWidget {
  final double value; // Glucose level in mg/dL
  final double maxValue = 400; // ✅ Fixed max glucose level

  const CircularGaugeWidget({super.key, required this.value});

  @override
  Widget build(BuildContext context) {
    double progress = (value / maxValue).clamp(0.0, 1.0); // Normalize progress

    return SizedBox(
      width: 300,
      height: 300,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // **Blue Expanding Gradient Background**
          Container(
            width: 280,
            height: 280,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment(0.37, -0.93),
                end: Alignment(-0.37, 0.93),
                colors: [
                  Color(0xFFD6E6FD),
                  Colors.white
                ], // ✅ Expanding outward
              ),
            ),
          ),

          // **White Inner Circle**
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Color(0xB283B5FB),
                  blurRadius: 40,
                  offset: Offset(10, 15),
                ),
              ],
            ),
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  value.toInt().toString(),
                  style: TextStyle(
                    color: Color(0xFF272727),
                    fontSize: 56,
                    fontFamily: 'Nexa-Trial',
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  'mg/dL',
                  style: TextStyle(
                    color: Color(0xFFB4B4B4),
                    fontSize: 16,
                    fontFamily: 'Nexa-Trial',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),

          // **Green Circular Progress Indicator (Inside White Circle, at the Edge)**
          CustomPaint(
            size: Size(180, 180), // ✅ Kept inside the white circle
            painter: CircularArcPainter(progress),
          ),

          // **Grey Numerical Labels at Key Positions**
          _buildLabel("0", Alignment.centerLeft), // 0 at the left
          _buildLabel("${(maxValue * 0.25).toInt()}",
              Alignment.bottomCenter), // 1/4 at bottom
          _buildLabel("${(maxValue * 0.5).toInt()}",
              Alignment.centerRight), // 1/2 at right
          _buildLabel("${(maxValue * 0.75).toInt()}",
              Alignment.topCenter), // 3/4 at top
        ],
      ),
    );
  }

  // **Helper Function to Create Grey Labels at Key Positions**
  Widget _buildLabel(String text, Alignment alignment) {
    return Align(
      alignment: alignment,
      child: Padding(
        padding: const EdgeInsets.all(8.0), // Adjust spacing
        child: Text(
          text,
          style: TextStyle(
            color: Color(0xFFB4B4B4),
            fontSize: 14,
            fontFamily: 'Nexa-Trial',
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}

// **Custom Painter for Green Arc (Counterclockwise)**
class CircularArcPainter extends CustomPainter {
  final double progress;

  CircularArcPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint progressPaint = Paint()
      ..shader = LinearGradient(
        colors: [Color(0xFF008E6C), Color(0xFF01C596)],
      ).createShader(Rect.fromCircle(
          center: Offset(size.width / 2, size.height / 2),
          radius: size.width / 2))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12 // ✅ Adjust thickness for smooth curve
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height / 2);
    final radius =
        size.width / 2 - 10; // ✅ Ensures arc is right next to the white circle

    double startAngle = -pi; // ✅ Starts at the left (0 mg/dL)
    double sweepAngle = -2 * pi * progress; // ✅ Accurate arc length

    // **Draw Green Progress Arc (Counterclockwise)**
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), startAngle,
        sweepAngle, false, progressPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
