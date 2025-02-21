import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class GlucoseTrendSvgWidget extends StatelessWidget {
  final List<Map<String, dynamic>> glucoseData;
  final double width;
  final double height;
  final double minY;
  final double maxY;
  final double maxX;

  const GlucoseTrendSvgWidget({
    super.key,
    required this.glucoseData,
    this.width = 400,
    this.height = 200,
    this.minY = 50,
    this.maxY = 200,
    required this.maxX,
  });

  @override
  Widget build(BuildContext context) {
    List<Offset> normalizedData =
        normalizeGlucoseData(glucoseData, width, height, minY, maxY, maxX);
    String svgPath = generateSvgPath(normalizedData);

    return Container(
      width: width,
      height: height,
      child: SvgPicture.string(
        '''
        <svg width="$width" height="$height" viewBox="0 0 $width $height" xmlns="http://www.w3.org/2000/svg">
          <defs>
            <linearGradient id="glucoseGradient" x1="0" y1="0" x2="0" y2="100%" gradientUnits="userSpaceOnUse">
              <stop offset="0%" stop-color="#018767"/>
              <stop offset="100%" stop-color="#02C697"/>
            </linearGradient>
          </defs>
          
          <path d="$svgPath" stroke="url(#glucoseGradient)" stroke-width="3" fill="transparent" stroke-linecap="round"/>
        </svg>
        ''',
        fit: BoxFit.contain,
      ),
    );
  }

  List<Offset> normalizeGlucoseData(List<Map<String, dynamic>> data,
      double width, double height, double minY, double maxY, double maxX) {
    if (data.isEmpty) return [];

    // Find min and max timestamps
    DateTime startTime = data.first["timestamp"];
    DateTime endTime = data.last["timestamp"];
    double totalDuration = endTime.difference(startTime).inSeconds.toDouble();

    return data.map((entry) {
      DateTime timestamp = entry["timestamp"];
      double elapsedTime = timestamp
          .difference(startTime)
          .inSeconds
          .toDouble(); // Convert to seconds

      double x = (elapsedTime / totalDuration) * width; // Normalize time range
      double y = height -
          ((entry["value"] - minY) /
              (maxY - minY) *
              height); // Normalize glucose value

      return Offset(x, y);
    }).toList();
  }

  // ✅ Add the missing function here!
  String generateSvgPath(List<Offset> points) {
    if (points.isEmpty) return "";

    final StringBuffer path = StringBuffer();
    path.write("M${points.first.dx},${points.first.dy} "); // Start point

    for (int i = 1; i < points.length - 1; i++) {
      double prevX = points[i - 1].dx;
      double prevY = points[i - 1].dy;
      double currX = points[i].dx;
      double currY = points[i].dy;
      double nextX = points[i + 1].dx;
      double nextY = points[i + 1].dy;

      // **Make Bezier control points more dynamic**
      double cp1X = currX - (currX - prevX) * 0.2;
      double cp1Y = currY - (currY - prevY) * 0.2;
      double cp2X = currX + (nextX - currX) * 0.2;
      double cp2Y = currY + (nextY - currY) * 0.2;

      path.write("C$cp1X,$cp1Y $cp2X,$cp2Y $nextX,$nextY ");
    }

    return path.toString();
  }
}
