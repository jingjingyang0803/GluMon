import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomNavButton extends StatelessWidget {
  final bool isActive;

  const CustomNavButton({
    super.key,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // ✅ 3rd Layer: Outer Blue Glow with Clean Boundary
        Container(
          width: 90, // Ensure it's larger than the white ring
          height: 90,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                Color(0xFFD0E7FF), // Light blue (glow source)
                Color(0xFFB0D0FF), // Slightly darker blue towards the edges
              ],
              stops: [0.3, 1.0], // Glow intensity shift
              center: Alignment(-0.5, -0.5), // Move glow towards top-left
              focal: Alignment(
                  -0.7, -0.7), // Make the glow stronger towards top-left
              radius: 0.8, // Controls how far the glow spreads
            ),
          ),
        ),

        // ✅ 2nd Layer: White Ring (Middle Border)
        Container(
          width: 70, // Slightly bigger than green button
          height: 70,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white, // White ring
          ),
        ),

        // ✅ 1st Layer: Inner Green Circle (Core Button)
        Container(
          width: 50, // Smaller than white ring
          height: 50,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [Color(0xFF17D0A3), Color(0xFF018767)], // Green Gradient
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Center(
            child: SvgPicture.asset(
              'assets/icons/bluetooth-wave-svgrepo-com.svg',
              width: 32,
              height: 32,
              colorFilter: const ColorFilter.mode(
                Colors.white, BlendMode.srcIn, // Adjust icon color
              ),
            ),
          ),
        ),
      ],
    );
  }
}
