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
            topLeft: Radius.circular(11), // Top-left corner
            topRight: Radius.circular(11), // Top-right corner
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
          crossAxisAlignment: CrossAxisAlignment
              .end, // Align the children to the bottom of the row
          children: [
            // Value text
            Text(
              value,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontFamily: 'Nexa-Trial',
                fontWeight: FontWeight.w700,
              ),
            ),
            // Unit text, smaller and aligned at the bottom
            Padding(
              padding: const EdgeInsets.only(bottom: 4), // Adjust spacing
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: ' mg', // Normal text
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontFamily: 'Nexa-Trial',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    TextSpan(
                      text: '/', // ✅ Different font for `/`
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    TextSpan(
                      text: 'dL', // Normal text continues
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontFamily: 'Nexa-Trial',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.7),
            fontSize: 13,
            fontFamily: 'Nexa-Trial',
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
