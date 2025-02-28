import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class GlucoseWaveWidget extends StatelessWidget {
  final bool isConnected;

  // Define colors for connected/disconnected states
  final String connectedColor = "#7DA9FD"; // Softer blue
  final String disconnectedColor = "#CECECE"; // Light gray

  const GlucoseWaveWidget({super.key, required this.isConnected});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.string(
      '''
      <svg width="300" height="80" viewBox="0 0 300 80" fill="none" xmlns="http://www.w3.org/2000/svg">
        <defs>
          <!-- ✅ Define Glow Effect -->
          <filter id="glowEffect" x="-20" y="-20" width="340" height="120">
            <feGaussianBlur stdDeviation="5" result="glow" />
            <feMerge>
              <feMergeNode in="glow" />
              <feMergeNode in="glow" />
            </feMerge>
          </filter>
        </defs>

        <!-- ✅ Glow Effect (Soft Light Under the Wave) -->
        <path d="M-5.50537 51.8948C0.980354 43.4949 17.1947 35.0949 30.1661 68.6947C35.2749 78.3993 38.5976 79.0549 59.3519 64.495C62.5947 62.1616 72.6476 51.895 86.9162 29.4952C89.0781 26.6952 95.672 25.2952 104.752 42.0951C116.102 63.095 124.209 28.0951 138.802 37.895C150.476 45.735 158.8 56.0949 161.502 60.2949C167.072 67.1947 170.906 66.1749 176.095 50.495C182.581 30.8951 198.654 14.7395 206.902 13.1327C214.353 11.6811 227.981 12.6952 237.709 39.295C239.767 43.7669 243.871 44.6149 249.059 37.8949C255.545 29.4949 260.719 47.2496 263.652 49.0948C268.136 51.9157 276.624 40.6949 281.488 30.8949C286.255 21.2906 297.252 3.61816 303.794 1.5988C303.927 1.55768 304.059 1.52306 304.188 1.49512"
        stroke="${isConnected ? "#A0C4FF" : "#E0E0E0"}"
        stroke-width="6"
        stroke-linecap="round"
        opacity="0.3"
        filter="url(#glowEffect)" />  <!-- ✅ Apply Glow Effect -->

        <!-- ✅ Main Wave Path -->
        <path d="M-5.50537 51.8948C0.980354 43.4949 17.1947 35.0949 30.1661 68.6947C35.2749 78.3993 38.5976 79.0549 59.3519 64.495C62.5947 62.1616 72.6476 51.895 86.9162 29.4952C89.0781 26.6952 95.672 25.2952 104.752 42.0951C116.102 63.095 124.209 28.0951 138.802 37.895C150.476 45.735 158.8 56.0949 161.502 60.2949C167.072 67.1947 170.906 66.1749 176.095 50.495C182.581 30.8951 198.654 14.7395 206.902 13.1327C214.353 11.6811 227.981 12.6952 237.709 39.295C239.767 43.7669 243.871 44.6149 249.059 37.8949C255.545 29.4949 260.719 47.2496 263.652 49.0948C268.136 51.9157 276.624 40.6949 281.488 30.8949C286.255 21.2906 297.252 3.61816 303.794 1.5988C303.927 1.55768 304.059 1.52306 304.188 1.49512"
        stroke="${isConnected ? connectedColor : disconnectedColor}"
        stroke-width="1.5"
        stroke-linecap="round"/>
      </svg>
      ''',
      width: 300,
      height: 80,
    );
  }
}
