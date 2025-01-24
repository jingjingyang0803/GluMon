import 'package:flutter/material.dart';

class SensorStatusCard extends StatelessWidget {
  final bool isConnected;
  final int batteryLevel; // Battery percentage

  const SensorStatusCard({
    super.key,
    required this.isConnected,
    required this.batteryLevel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity, // Full width
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 5,
            spreadRadius: 2,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Connection Status
          Row(
            children: [
              Icon(
                isConnected ? Icons.check_circle : Icons.error,
                color: isConnected ? Colors.green : Colors.red,
                size: 24,
              ),
              SizedBox(width: 8),
              Text(
                isConnected ? 'Connected' : 'Disconnected',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isConnected ? Colors.green : Colors.red,
                ),
              ),
            ],
          ),

          // Battery Level
          Row(
            children: [
              Icon(
                Icons.battery_full,
                color: batteryLevel > 20 ? Colors.green : Colors.red,
                size: 24,
              ),
              SizedBox(width: 8),
              Text(
                '$batteryLevel%', // Show battery percentage
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: batteryLevel > 20 ? Colors.black : Colors.red,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
