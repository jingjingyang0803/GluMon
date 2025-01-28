import 'dart:convert';
import 'dart:io' show Platform;
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart' as bt_ble; // BLE
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart'
    as bt_serial; // Classic Bluetooth
import 'package:google_fonts/google_fonts.dart';

import '../utils/color_utils.dart';

class BluetoothPage extends StatefulWidget {
  const BluetoothPage({super.key});

  @override
  BluetoothPageState createState() => BluetoothPageState();
}

class BluetoothPageState extends State<BluetoothPage> {
  bt_serial.FlutterBluetoothSerial bluetooth =
      bt_serial.FlutterBluetoothSerial.instance;
  bt_serial.BluetoothConnection? classicConnection;
  List<bt_serial.BluetoothDevice> classicDevices = [];

  List<bt_ble.ScanResult> bleDevices = [];
  bt_serial.BluetoothDevice? selectedClassicDevice;
  bt_ble.BluetoothDevice? selectedBleDevice;

  bool isClassicConnected = false;
  bool isBleConnected = false;
  String receivedData = "No data yet";

  @override
  void initState() {
    super.initState();
    _scanDevices();
  }

  /// **Scan for Bluetooth devices**
  void _scanDevices() async {
    if (Platform.isAndroid) {
      // Scan for Bluetooth Classic devices
      List<bt_serial.BluetoothDevice> bondedDevices =
          await bluetooth.getBondedDevices();
      setState(() {
        classicDevices = bondedDevices;
      });
    }

    // Scan for BLE devices
    bt_ble.FlutterBluePlus.startScan(timeout: const Duration(seconds: 5));

    // Correct way to listen to scan results
    bt_ble.FlutterBluePlus.scanResults
        .listen((List<bt_ble.ScanResult> results) {
      setState(() {
        bleDevices = results;
      });
    });
  }

  /// **Connect to Classic Bluetooth (SPP)**
  Future<void> _connectToClassicDevice(bt_serial.BluetoothDevice device) async {
    try {
      classicConnection =
          await bt_serial.BluetoothConnection.toAddress(device.address);
      setState(() {
        isClassicConnected = true;
        selectedClassicDevice = device;
      });

      print("✅ Connected to ${device.name} via Bluetooth Classic");

      classicConnection!.input!.listen((Uint8List data) {
        String decodedData = utf8.decode(data);
        print("📡 Received Data: $decodedData");

        setState(() {
          receivedData = decodedData;
        });
      });
    } catch (e) {
      print("❌ Error connecting: $e");
      setState(() {
        isClassicConnected = false;
      });
    }
  }

  /// **Connect to BLE Device**
  Future<void> _connectToBleDevice(bt_ble.BluetoothDevice device) async {
    try {
      await device.connect();
      setState(() {
        isBleConnected = true;
        selectedBleDevice = device;
      });

      print("✅ Connected to ${device.platformName} via BLE");

      // Subscribe to a characteristic (Assuming ESP32/Arduino has a notify characteristic)
      var services = await device.discoverServices();
      for (var service in services) {
        for (var characteristic in service.characteristics) {
          if (characteristic.properties.notify) {
            await characteristic.setNotifyValue(true);
            characteristic.lastValueStream.listen((value) {
              String decodedData = utf8.decode(value);
              print("📡 Received Data from BLE: $decodedData");

              setState(() {
                receivedData = decodedData;
              });
            });
          }
        }
      }
    } catch (e) {
      print("❌ Error connecting to BLE: $e");
      setState(() {
        isBleConnected = false;
      });
    }
  }

  /// **Disconnect Bluetooth Classic**
  void _disconnectClassic() {
    if (classicConnection != null) {
      classicConnection!.finish();
      setState(() {
        isClassicConnected = false;
        selectedClassicDevice = null;
      });
      print("🔌 Disconnected from Classic Bluetooth");
    }
  }

  /// **Disconnect BLE**
  void _disconnectBle() {
    if (selectedBleDevice != null) {
      selectedBleDevice!.disconnect();
      setState(() {
        isBleConnected = false;
        selectedBleDevice = null;
      });
      print("🔌 Disconnected from BLE");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text('Bluetooth',
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
            _buildSectionTitle("Classic Bluetooth (SPP) Devices"),
            _buildDeviceList(classicDevices, _connectToClassicDevice),
            _buildSectionTitle("BLE Devices"),
            _buildDeviceList(
                bleDevices.map((r) => r.device).toList(), _connectToBleDevice),
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
  Widget _buildDeviceList(List devices, Function connectFunction) {
    return devices.isEmpty
        ? const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text("No devices found"),
          )
        : Column(
            children: devices.map((device) {
              return ListTile(
                leading:
                    Icon(Icons.bluetooth, color: primaryDarkBlue, size: 28),
                title: Text(
                    device.name.isNotEmpty ? device.name : "Unknown Device"),
                subtitle: Text(device.id.toString()),
                trailing: ElevatedButton(
                  onPressed: () => connectFunction(device),
                  child: const Text("Connect"),
                ),
              );
            }).toList(),
          );
  }

  /// **Connection Status UI**
  Widget _buildConnectionStatus() {
    return _buildCardTile(
      title: "Current Connection",
      icon: (isClassicConnected || isBleConnected)
          ? Icons.bluetooth_connected
          : Icons.bluetooth_disabled,
      child: (isClassicConnected || isBleConnected)
          ? Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.bluetooth_connected,
                        color: Colors.green, size: 30),
                    const SizedBox(width: 10),
                    Text(
                      "Connected to: ${isClassicConnected ? selectedClassicDevice?.name : selectedBleDevice?.platformName}",
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
                  onPressed:
                      isClassicConnected ? _disconnectClassic : _disconnectBle,
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
            color: Colors.black.withValues(alpha: 0.05),
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
