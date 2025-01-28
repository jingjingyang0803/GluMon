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
  bool isScanning = false;
  String receivedData = "No data yet";

  @override
  void initState() {
    super.initState();
    _scanDevices();
  }

  /// **Scan for Bluetooth devices**
  void _scanDevices() async {
    try {
      setState(() => isScanning = true);

      // Check if Bluetooth is available
      if (!await bt_ble.FlutterBluePlus.isSupported ||
          (await bt_ble.FlutterBluePlus.adapterState.first) !=
              bt_ble.BluetoothAdapterState.on) {
        print("❌ Bluetooth is OFF. Cannot start scanning.");
        setState(() => isScanning = false);
        return;
      }

      // Stop any ongoing scan
      await bt_ble.FlutterBluePlus.stopScan();
      await Future.delayed(const Duration(milliseconds: 500)); // Small delay

      // Scan for Classic Bluetooth devices (SPP)
      if (Platform.isAndroid) {
        List<bt_serial.BluetoothDevice> bondedDevices =
            await bluetooth.getBondedDevices();
        if (mounted) {
          setState(() => classicDevices = bondedDevices);
        }
      }

      // Start BLE scanning with timeout
      bt_ble.FlutterBluePlus.startScan(timeout: const Duration(seconds: 5));

      // Listen for BLE scan results
      bt_ble.FlutterBluePlus.scanResults
          .listen((List<bt_ble.ScanResult> results) {
        if (mounted && bleDevices.length != results.length) {
          setState(() => bleDevices = results);
        }
      });

      print("🔍 Scanning for Bluetooth devices...");
    } catch (e) {
      print("❌ Error scanning: $e");
      setState(() => isScanning = false);
    }

    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        setState(() => isScanning = false);
      }
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

      classicConnection!.input!.listen((Uint8List data) {
        String decodedData = utf8.decode(data);
        if (mounted) {
          setState(() {
            receivedData = decodedData;
          });
        }
      });
    } catch (e) {
      if (mounted) {
        setState(() {
          isClassicConnected = false;
        });
      }
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

      var services = await device.discoverServices();
      for (var service in services) {
        for (var characteristic in service.characteristics) {
          if (characteristic.properties.notify) {
            await characteristic.setNotifyValue(true);
            characteristic.lastValueStream.listen((value) {
              String decodedData = utf8.decode(value);
              if (mounted) {
                setState(() {
                  receivedData = decodedData;
                });
              }
            });
          }
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isBleConnected = false;
        });
      }
    }
  }

  /// **Disconnect Classic Bluetooth**
  void _disconnectClassic() {
    if (classicConnection != null) {
      classicConnection!.finish();
      setState(() {
        isClassicConnected = false;
        selectedClassicDevice = null;
      });
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
    }
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (isScanning) const Center(child: CircularProgressIndicator()),

            // Use Expanded to prevent overflow
            Expanded(
              child: ListView(
                children: [
                  _buildDeviceCard("Classic Bluetooth (SPP) Devices",
                      classicDevices, _connectToClassicDevice),
                  const SizedBox(height: 10),
                  _buildDeviceCard(
                      "BLE Devices",
                      bleDevices.map((r) => r.device).toList(),
                      _connectToBleDevice),
                  const SizedBox(height: 10),
                  _buildConnectionStatusCard(),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _scanDevices,
        backgroundColor: primaryDarkBlue,
        child: const Icon(Icons.refresh),
      ),
    );
  }

  /// **Device List Wrapped in a Card**
  Widget _buildDeviceCard(
      String title, List devices, Function connectFunction) {
    return Card(
      elevation: 4,
      color: Colors.white, // Set the card background color to white
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

            // Wrapping the list inside a SizedBox to limit height and enable scrolling
            SizedBox(
              height:
                  devices.isEmpty ? 20 : 200, // Adjust this height as needed
              child: devices.isEmpty
                  ? const Center(
                      child: Text("No devices found",
                          style: TextStyle(color: Colors.grey)),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      physics:
                          const AlwaysScrollableScrollPhysics(), // Enables scrolling
                      itemCount: devices.length,
                      itemBuilder: (context, index) {
                        var device = devices[index];
                        return ListTile(
                          leading: Icon(Icons.bluetooth,
                              color: primaryDarkBlue, size: 28),
                          title: Text(device.name.isNotEmpty
                              ? device.name
                              : "Unknown Device"),
                          subtitle: Text(device.id.toString()),
                          trailing: ElevatedButton(
                            onPressed: () => connectFunction(device),
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
    return Card(
      elevation: 4,
      color: Colors.white, // Set the card background color to white
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(
                  (isClassicConnected || isBleConnected)
                      ? Icons.bluetooth_connected
                      : Icons.bluetooth_disabled,
                  color: (isClassicConnected || isBleConnected)
                      ? Colors.green
                      : Colors.red,
                  size: 30,
                ),
                const SizedBox(width: 10),
                Text(
                  "Connected to: ${isClassicConnected ? selectedClassicDevice?.name : selectedBleDevice?.platformName ?? "None"}",
                  style: GoogleFonts.poppins(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text("Received Data: $receivedData",
                style: GoogleFonts.poppins(
                    fontSize: 14, fontWeight: FontWeight.w500),
                textAlign: TextAlign.center),
            const SizedBox(height: 20),
            if (isClassicConnected || isBleConnected)
              ElevatedButton(
                onPressed:
                    isClassicConnected ? _disconnectClassic : _disconnectBle,
                style:
                    ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
                child: const Text("Disconnect"),
              ),
          ],
        ),
      ),
    );
  }
}
