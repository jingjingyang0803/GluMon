import 'dart:math';

import 'package:flutter/material.dart';

class CircularGaugeWidget extends StatelessWidget {
  final String value; // Glucose level in mg/dL
  final double maxValue = 400; // ✅ Fixed max glucose level

  const CircularGaugeWidget({super.key, required this.value});

  @override
  Widget build(BuildContext context) {
    double progress =
        (double.tryParse(value) ?? 0.0 / maxValue).clamp(0.0, 1.0);

    // ✅ Start at 9 o’clock and move counterclockwise
    double startAngle = -pi;
    double sweepAngle = -2 * pi * progress; // ✅ Now counterclockwise!
    double angle = startAngle + sweepAngle; // ✅ Correct endpoint angle

    // ✅ Define component radii
    double canvasSize = 300; // Define the canvas size explicitly

    double whiteCircleRadius = 100; // Center white circle
    double blueBlurRadius = 140; // Outer blue glow
    double strokeWidth = 20; // ✅ Stroke width for arc
    double greenArcRadius =
        whiteCircleRadius - strokeWidth / 2; // Green progress arc
    double endpointRadius = greenArcRadius;

    double labelRadius =
        (canvasSize / 2) - (whiteCircleRadius / 2); // Adjust for positioning

    return SizedBox(
      width: canvasSize,
      height: canvasSize,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // **Blue background glow**
          _buildBlurCircle(
              blueBlurRadius, Color(0xFFD6E6FD).withValues(alpha: 0.8)),

          // **White center circle**
          _buildCenterCircle(canvasSize, whiteCircleRadius),

          // **Green arc progress indicator (Counterclockwise)**
          CustomPaint(
            size:
                Size(canvasSize, canvasSize), // Keep it inside the white circle
            painter: CircularArcPainter(progress, greenArcRadius, strokeWidth),
          ),

          // **Blurred endpoint indicator (corrected position)**
          _buildEndpointGlow(canvasSize, endpointRadius, angle),

          // **Text display for glucose level**
          _buildText(value.toString()),

          _buildLabel("0", -labelRadius - 60, 0),
          _buildLabel("100", 0, labelRadius + 60),
          _buildLabel("200", labelRadius + 70, 0),
          _buildLabel("300", 0, -labelRadius - 60),
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
  Widget _buildText(String value) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          value,
          style: TextStyle(
            color: Color(0xFF272727),
            fontSize: 56,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          'mg/dL',
          style: TextStyle(
            color: Color(0xFFB4B4B4),
            fontSize: 13,
            fontFamily: 'Poppins',
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

    // **Sizes**
    double outerGlowSize = 45; // Outer glow container size
    double innerCircleSize = 20; // Inner white circle size
    double glowBlur = 30; // The blur radius of the glow effect

    // **Offset correction using half of the outer glow size**
    double correction = outerGlowSize / 2;

    print('endpointRadius: $endpointRadius');
    print('dx: $dx, dy: $dy');
    print('Actual Position: (${centerX + dx}, ${centerY + dy})');
    print('Correction applied: $correction');

    return Positioned(
      left: centerX + dx - correction,
      top: centerY + dy - correction,
      child: Container(
        width: outerGlowSize,
        height: outerGlowSize,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Color(0xFFDEECFE).withValues(alpha: 0.8),
              blurRadius: glowBlur,
              spreadRadius: 8,
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // **Outer glow effect (larger)**
            Container(
              width: outerGlowSize - 5,
              height: outerGlowSize - 5,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.2),
                border: Border.all(width: 1.5, color: Color(0xFFE2EEFF)),
              ),
            ),
            // **Inner endpoint circle (smaller)**
            Container(
              width: innerCircleSize,
              height: innerCircleSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
            ),
          ],
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
    print('size: $size, centerX: $centerX');

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
