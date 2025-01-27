import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils/color_utils.dart'; // Ensure you have this file for theme colors

class BluetoothPage extends StatefulWidget {
  const BluetoothPage({super.key});

  @override
  BluetoothPageState createState() => BluetoothPageState();
}

class BluetoothPageState extends State<BluetoothPage> {
  FlutterBluetoothSerial bluetooth = FlutterBluetoothSerial.instance;
  BluetoothConnection? connection;
  List<BluetoothDevice> devices = [];
  bool isConnected = false;
  String receivedData = "No data yet";
  BluetoothDevice? selectedDevice;

  @override
  void initState() {
    super.initState();
    _scanDevices();
  }

  /// **Scan for Bluetooth devices**
  void _scanDevices() async {
    List<BluetoothDevice> bondedDevices = await bluetooth.getBondedDevices();
    setState(() {
      devices = bondedDevices;
    });
  }

  /// **Connect to selected device**
  Future<void> _connectToDevice(BluetoothDevice device) async {
    try {
      connection = await BluetoothConnection.toAddress(device.address);
      setState(() {
        isConnected = true;
        selectedDevice = device;
      });

      print("✅ Connected to ${device.name}");

      connection!.input!.listen((Uint8List data) {
        String decodedData = utf8.decode(data);
        print("📡 Received Data: $decodedData");

        setState(() {
          receivedData = decodedData;
        });
      });
    } catch (e) {
      print("❌ Error connecting: $e");
      setState(() {
        isConnected = false;
      });
    }
  }

  /// **Disconnect Bluetooth**
  void _disconnect() {
    if (connection != null) {
      connection!.finish();
      setState(() {
        isConnected = false;
        selectedDevice = null;
      });
      print("🔌 Disconnected");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100], // Match Settings Page background
      appBar: AppBar(
        title: Text('',
            style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: primaryDarkBlue)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: primaryDarkBlue),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
        child: Column(
          children: [
            _buildSectionTitle("Available Devices"),
            _buildDeviceList(),
            _buildSectionTitle("Connection Status"),
            _buildConnectionStatus(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  /// **Section Title**
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, bottom: 8.0, left: 8.0),
      child: Text(
        title,
        style: GoogleFonts.poppins(
            fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey[700]),
      ),
    );
  }

  /// **Device List UI**
  Widget _buildDeviceList() {
    return _buildCardTile(
      title: "Select a Device to Connect",
      icon: Icons.bluetooth,
      child: devices.isEmpty
          ? Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "No devices found",
                style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            )
          : Column(
              children: devices.map((device) {
                return ListTile(
                  leading:
                      Icon(Icons.bluetooth, color: primaryDarkBlue, size: 28),
                  title: Text(device.name ?? "Unknown Device",
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
                  subtitle: Text(device.address),
                  trailing: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryDarkBlue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () => _connectToDevice(device),
                    child: const Text("Connect"),
                  ),
                );
              }).toList(),
            ),
    );
  }

  /// **Connection Status UI**
  Widget _buildConnectionStatus() {
    return _buildCardTile(
      title: "Current Connection",
      icon: isConnected ? Icons.bluetooth_connected : Icons.bluetooth_disabled,
      child: isConnected
          ? Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.bluetooth_connected,
                        color: Colors.green, size: 30),
                    const SizedBox(width: 10),
                    Text(
                      "Connected to: ${selectedDevice!.name}",
                      style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.green),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  "Received Data: $receivedData",
                  style: GoogleFonts.poppins(
                      fontSize: 14, fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _disconnect,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Text("Disconnect", style: TextStyle(fontSize: 16)),
                  ),
                ),
              ],
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "Not connected",
                style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.red),
                textAlign: TextAlign.center,
              ),
            ),
    );
  }

  /// **Reusable Card UI**
  Widget _buildCardTile(
      {required String title, required IconData icon, required Widget child}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: primaryDarkBlue, size: 24),
              const SizedBox(width: 10),
              Text(title,
                  style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black)),
            ],
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }
}
