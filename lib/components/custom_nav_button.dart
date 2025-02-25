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
    return GestureDetector(
      child: Stack(
        alignment: Alignment.center,
        children: [
          // ✅ Outer Glow Effect
          Container(
            width: 100, // Larger for glow
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: isActive
                  ? [
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.4), // Glow color
                        blurRadius: 40,
                        spreadRadius: 10,
                      ),
                    ]
                  : [],
            ),
          ),

          // ✅ Thinner White Ring
          Container(
            width: 70, // Reduced size for thinner ring
            height: 70,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white, // White border effect
            ),
          ),

          // ✅ Inner Green Circle with Gradient
          Container(
            width: 60, // Slightly smaller than white ring
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF17D0A3),
                  Color(0xFF018767)
                ], // Green Gradient
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 5,
                  spreadRadius: 2,
                  offset: const Offset(2, 2),
                ),
              ],
            ),
            child: Center(
              child: SvgPicture.asset(
                'assets/icons/bluetooth-wave-svgrepo-com.svg',
                width: 32,
                height: 32,
                colorFilter: const ColorFilter.mode(
                  Colors.white, BlendMode.srcIn, // Adjust color dynamically
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
