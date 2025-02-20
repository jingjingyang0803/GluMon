import 'package:flutter/material.dart';
import 'package:glu_mon/utils/color_utils.dart';

class HealthCategoryRow extends StatefulWidget {
  @override
  _HealthCategoryRowState createState() => _HealthCategoryRowState();
}

class _HealthCategoryRowState extends State<HealthCategoryRow> {
  String selectedCategory = 'Glucose'; // Default selected tab
  String selectedFilter = 'Daily'; // Default filter option

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
          MainAxisAlignment.spaceBetween, // Aligns left & right elements
      children: [
        // **Health Categories**
        Row(
          children: [
            const SizedBox(width: 20), // Spacing
            _buildCategory('Glucose'),
            const SizedBox(width: 20), // Spacing
            _buildCategory('B.P'),
            const SizedBox(width: 20), // Spacing
            _buildCategory('Heart Rate'),
          ],
        ),

        // **Dropdown for Time Filter**
        Row(
          children: [
            Text(
              selectedFilter,
              style: TextStyle(
                color: Color(0xFF272727),
                fontSize: 16,
                fontFamily: 'Nexa Text-Trial',
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(width: 4),
            Icon(Icons.keyboard_arrow_down, size: 16, color: Color(0xFF272727)),
          ],
        ),
      ],
    );
  }

  // **Category Builder Function**
  Widget _buildCategory(String title) {
    bool isSelected = title == selectedCategory;
    double textWidth = _calculateTextWidth(title);

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCategory = title; // Update selected tab on tap
        });
      },
      child: Column(
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected ? primaryBlack : primaryGrey,
              fontSize: 17,
              fontFamily: 'Nexa-Trial',
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4), // Spacing for the indicator
          if (isSelected)
            Container(
              width: textWidth + 8, // ✅ Dynamic width based on text
              height: 5,
              decoration: BoxDecoration(
                color: primaryOrange,
                borderRadius: BorderRadius.circular(36),
              ),
            ),
        ],
      ),
    );
  }

  // **Calculate Text Width Dynamically**
  double _calculateTextWidth(String text) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          fontSize: 17,
          fontFamily: 'Nexa-Trial',
          fontWeight: FontWeight.w400,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    return textPainter.width;
  }
}
