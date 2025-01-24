import 'package:flutter/material.dart';

class HumidityTemperatureCard extends StatelessWidget {
  final double humidity;
  final double temperature;

  const HumidityTemperatureCard({
    super.key,
    required this.humidity,
    required this.temperature,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
          // Temperature
          Column(
            children: [
              Icon(Icons.thermostat, color: Colors.red, size: 30),
              SizedBox(height: 4),
              Text(
                "$temperature°C",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
              Text(
                "Temperature",
                style: TextStyle(fontSize: 12, color: Colors.black54),
              ),
            ],
          ),

          // Humidity
          Column(
            children: [
              Icon(Icons.water_drop, color: Colors.blue, size: 30),
              SizedBox(height: 4),
              Text(
                "$humidity%",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              Text(
                "Humidity",
                style: TextStyle(fontSize: 12, color: Colors.black54),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
