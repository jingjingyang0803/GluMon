import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart' as bt_ble;
import 'package:glu_mon/components/custom_button.dart';
import 'package:google_fonts/google_fonts.dart';

import '../services/bluetooth_service.dart';
import '../services/database_service.dart';
import '../utils/color_utils.dart';

class BluetoothPage extends StatefulWidget {
  const BluetoothPage({super.key});

  @override
  BluetoothPageState createState() => BluetoothPageState();
}

class BluetoothPageState extends State<BluetoothPage> {
  late final BluetoothService _bluetoothService;

  final DatabaseService databaseService =
      DatabaseService(); // Initialize Database

  @override
  void initState() {
    super.initState();
    _bluetoothService = BluetoothService(); // Singleton instance

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_bluetoothService.isConnected) {
        _bluetoothService.emitCurrentDeviceName(); // Ensure UI updates
      } else {
        _bluetoothService.scanDevices();
      }
    });
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text(
          '',
          style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: primaryDarkBlue),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: primaryDarkBlue),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: StreamBuilder<bool>(
          stream: _bluetoothService.connectionStatusStream,
          builder: (context, snapshot) {
            bool isConnected = snapshot.data ?? false;

            return Column(
              children: [
                // ✅ Always Show Refresh Button
                SizedBox(
                  width: 140, // ✅ Set desired width
                  child: CustomButton(
                    text: "Refresh",
                    onPressed: _bluetoothService.scanDevices,
                    backgroundColor: primaryGreen,
                    textColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 8), // ✅ Smaller padding
                  ),
                ),

                const SizedBox(height: 20),

                // ✅ Show List of Devices Only When Disconnected
                if (!(isConnected ??
                    false)) // Ensure null safety and default to false
                  StreamBuilder<List<bt_ble.ScanResult>>(
                    stream: _bluetoothService.bleDevicesStream,
                    builder: (context, snapshot) {
                      return _buildDeviceCard(
                        "",
                        snapshot.data?.map((r) => r.device).toList() ?? [],
                        _bluetoothService.connectToBleDevice,
                      );
                    },
                  ),

                const SizedBox(height: 10),

                // ✅ Show Connection Status Only When Connected
                if (isConnected) _buildConnectionStatusCard(),
              ],
            );
          },
        ),
      ),
    );
  }

  /// **Device List Wrapped in a Card**
  Widget _buildDeviceCard(
      String title, List devices, Function connectFunction) {
    return Card(
      elevation: 4,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: devices.isEmpty ? 20 : 200,
              child: devices.isEmpty
                  ? const Center(
                      child: Text("No devices found",
                          style: TextStyle(color: Colors.grey)),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: devices.length,
                      itemBuilder: (context, index) {
                        var device = devices[index];
                        return ListTile(
                          leading: Icon(Icons.bluetooth,
                              color: primaryDarkBlue, size: 28),
                          title: Text(device.name.isNotEmpty
                              ? device.name
                              : "Unknown Device"),
                          // subtitle: Text(device.id.toString()),
                          trailing: ElevatedButton(
                            onPressed: () => connectFunction(device),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: lightGreen, // ✅ Green background
                              foregroundColor: Colors.white, // ✅ White text
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8), // Optional: Adjust padding
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    30), // Optional: Rounded corners
                              ),
                            ),
                            child: const Text("Connect"),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  /// **Connection Status Wrapped in a Card**
  Widget _buildConnectionStatusCard() {
    return StreamBuilder<bool>(
      stream: _bluetoothService.connectionStatusStream,
      builder: (context, snapshot) {
        bool isConnected = snapshot.data ?? false;

        return Card(
          elevation: 4,
          color: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      isConnected
                          ? Icons.bluetooth_connected
                          : Icons.bluetooth_disabled,
                      color: isConnected ? Colors.green : Colors.red,
                      size: 30,
                    ),
                    const SizedBox(width: 10),
                    StreamBuilder<String>(
                      stream: _bluetoothService.deviceNameStream,
                      builder: (context, snapshot) {
                        String deviceName = snapshot.data ?? "None";
                        return Text(
                          "Connected to: \n$deviceName",
                          style: GoogleFonts.poppins(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // ✅ Automatically save glucose readings to the database
                StreamBuilder<String>(
                  stream: _bluetoothService.dataStream,
                  builder: (context, snapshot) {
                    String receivedData = snapshot.data ?? "No data yet";

                    // ✅ Parse and save data whenever it updates
                    if (snapshot.hasData) {
                      try {
                        Map<String, dynamic> jsonData =
                            jsonDecode(receivedData);

                        double glucose = jsonData["glucose"] ?? 0.0;
                        double temperature = jsonData["temp"] ?? 0.0;
                        double humidity = jsonData["humidity"] ?? 0.0;
                        String timestamp = jsonData["timestamp"] ??
                            DateTime.now().toIso8601String();

                        // Save to database
                        databaseService.saveGlucoseReading({
                          'glucose_level': glucose,
                          'temperature': temperature,
                          'humidity': humidity,
                          'timestamp': timestamp,
                        });

                        print("✅ Data saved to database: $jsonData");
                      } catch (e) {
                        print("⚠️ JSON Parse Error: $e");
                      }
                    }

                    return Text(
                      receivedData,
                      style: GoogleFonts.poppins(
                          fontSize: 14, fontWeight: FontWeight.w500),
                      textAlign: TextAlign.center,
                    );
                  },
                ),
                const SizedBox(height: 20),

                if (isConnected)
                  SizedBox(
                    width: 140, // ✅ Set smaller width
                    child: CustomButton(
                      text: "Disconnect",
                      onPressed: _bluetoothService.disconnect,
                      backgroundColor: primaryOrange,
                      textColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 8), // ✅ Adjust padding
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
