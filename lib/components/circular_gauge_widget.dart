import 'dart:math';

import 'package:flutter/material.dart';

class CircularGaugeWidget extends StatelessWidget {
  final double value; // Glucose level in mg/dL
  final double maxValue = 400; // ✅ Fixed max glucose level

  const CircularGaugeWidget({super.key, required this.value});

  @override
  Widget build(BuildContext context) {
    double progress = (value / maxValue).clamp(0.0, 1.0); // Normalize progress

    // ✅ Start at 9 o’clock and move counterclockwise
    double startAngle = -pi;
    double sweepAngle = -2 * pi * progress; // ✅ Now counterclockwise!
    double angle = startAngle + sweepAngle; // ✅ Correct endpoint angle

    // ✅ Define component radii
    double canvasSize = 500; // Define the canvas size explicitly
    double centerX = canvasSize / 2;
    double centerY = canvasSize / 2;

    double whiteCircleRadius = 100; // Center white circle
    double blueBlurRadius = 140; // Outer blue glow
    double greenArcRadius = 90; // Green progress arc
    double strokeWidth = 20; // ✅ Stroke width for arc
    double endpointRadius = greenArcRadius - strokeWidth / 2;

    return SizedBox(
      width: 500,
      height: 500,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // **Blue background glow**
          _buildBlurCircle(blueBlurRadius, Color(0xFFD6E6FD).withOpacity(0.8)),

          // **White center circle**
          _buildCenterCircle(canvasSize, whiteCircleRadius),

          // **Green arc progress indicator (Counterclockwise)**
          CustomPaint(
            size: Size(240, 240), // Keep it inside the white circle
            painter: CircularArcPainter(progress, greenArcRadius, strokeWidth),
          ),

          // **Blurred endpoint indicator (corrected position)**
          _buildEndpointGlow(canvasSize, endpointRadius, angle),

          // **Text display for glucose level**
          _buildText(value),

          // **Numerical labels at key positions**
          _buildLabel("0", -190, 0),
          _buildLabel("100", 0, 140),
          _buildLabel("200", 140, 0),
          _buildLabel("300", 0, -140),
        ],
      ),
    );
  }

  // **Blue background glow effect**
  Widget _buildBlurCircle(double radius, Color color) {
    return Container(
      width: radius * 2,
      height: radius * 2,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color,
            blurRadius: 50,
            spreadRadius: 20,
          ),
        ],
      ),
    );
  }

  // **White center circle**
  Widget _buildCenterCircle(double canvasSize, double radius) {
    return Positioned(
      left: (canvasSize / 2) - radius,
      top: (canvasSize / 2) - radius,
      child: Container(
        width: radius * 2,
        height: radius * 2,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Color(0xB283B5FB),
              blurRadius: 120,
              offset: Offset(20, 30),
              spreadRadius: 10,
            ),
          ],
        ),
      ),
    );
  }

  // **Text display for glucose level**
  Widget _buildText(double value) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          value.toInt().toString(),
          style: TextStyle(
            color: Color(0xFF272727),
            fontSize: 56,
            fontFamily: 'Nexa-Trial',
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          'mg/dL',
          style: TextStyle(
            color: Color(0xFFB4B4B4),
            fontSize: 13,
            fontFamily: 'Nexa-Trial',
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  // **Numerical labels for key positions (0, 100, 200, 300)**
  Widget _buildLabel(String text, double dx, double dy) {
    return Align(
      alignment: Alignment(dx / 200, dy / 200), // Normalize between -1 and 1
      child: Text(
        text,
        style: TextStyle(
          color: Color(0xFFB4B4B4),
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  // **Blurred endpoint glow (Corrected Positioning)**
  Widget _buildEndpointGlow(
      double canvasSize, double endpointRadius, double angle) {
    double centerX = canvasSize / 2;
    double centerY = canvasSize / 2;

    double dx = endpointRadius * cos(angle);
    double dy = endpointRadius * sin(angle);

    return Positioned(
      left: centerX + dx - 20, // Offset based on actual element size
      top: centerY + dy - 20,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Color(0xFFDEECFE).withOpacity(0.8),
              blurRadius: 30,
              spreadRadius: 8,
            ),
          ],
        ),
        child: Center(
          child: Container(
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

// **Green arc progress indicator (Counterclockwise)**
class CircularArcPainter extends CustomPainter {
  final double progress;
  final double radius;
  final double strokeWidth;

  CircularArcPainter(this.progress, this.radius, this.strokeWidth);

  @override
  void paint(Canvas canvas, Size size) {
    double centerX = size.width / 2;
    double centerY = size.height / 2;

    final Paint progressPaint = Paint()
      ..shader = LinearGradient(
        colors: [Color(0xFF008E6C), Color(0xFF01C596)],
      ).createShader(
          Rect.fromCircle(center: Offset(centerX, centerY), radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    double startAngle = -pi; // ✅ Start at 9 o’clock
    double sweepAngle = -2 * pi * progress; // ✅ Counterclockwise drawing

    canvas.drawArc(
        Rect.fromCircle(center: Offset(centerX, centerY), radius: radius),
        startAngle,
        sweepAngle,
        false,
        progressPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
