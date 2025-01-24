import 'package:flutter/material.dart';

import '../utils/color_utils.dart';

class WelcomeTitle extends StatelessWidget {
  final String name;

  const WelcomeTitle({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      SizedBox(
        height: 20,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Welcome $name!',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: primaryBlack,
            ),
          ),
          ClipRRect(
            borderRadius:
                BorderRadius.circular(8), // Adjust for rounded corners
            child: Image.asset(
              'assets/images/profile.jpg',
              width: 60, // Adjust width
              height: 60, // Adjust height
              fit: BoxFit.cover, // Ensure the image covers the square
            ),
          )
        ],
      ),
    ]);
  }
}
