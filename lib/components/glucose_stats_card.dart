import 'package:flutter/material.dart';
import 'package:glu_mon/utils/color_utils.dart';

class GlucoseStatsCard extends StatelessWidget {
  final String averageValue;
  final String minValue;
  final String maxValue;

  const GlucoseStatsCard({
    super.key,
    required this.averageValue,
    required this.minValue,
    required this.maxValue,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      decoration: ShapeDecoration(
        color: primaryGreen,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12), // Top-left corner
            topRight: Radius.circular(12), // Top-right corner
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ValueCard(value: averageValue, label: 'Average'),
          ValueCard(value: minValue, label: 'Min'),
          ValueCard(value: maxValue, label: 'Max'),
        ],
      ),
    );
  }
}

class ValueCard extends StatelessWidget {
  final String value;
  final String label;

  const ValueCard({
    super.key,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              value,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 30.37,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              ' mg/dL', // You can adjust the unit as needed
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 13.02,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white.withOpacity(0.7),
            fontSize: 13.02,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
