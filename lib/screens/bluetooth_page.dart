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
    // Scan for Bluetooth Classic devices (SPP)
    if (Platform.isAndroid) {
      List<bt_serial.BluetoothDevice> bondedDevices =
          await bluetooth.getBondedDevices();
      setState(() {
        classicDevices = bondedDevices;
      });
    }

    // Scan for BLE devices (ESP32 BLE, Phones, MacBooks, etc.)
    bt_ble.FlutterBluePlus.startScan(timeout: const Duration(seconds: 5));

    bt_ble.FlutterBluePlus.scanResults
        .listen((List<bt_ble.ScanResult> results) {
      setState(() {
        bleDevices = results;
      });

      // Debug: Print all scanned BLE devices
      for (var result in results) {
        print(
            "🔍 BLE Device Found: ${result.device.remoteId}, Name: ${result.advertisementData.localName}");
      }
    });

    // Debug: Print all Classic Bluetooth devices
    for (var device in classicDevices) {
      print(
          "🔍 Classic Device Found: ${device.name}, Address: ${device.address}");
    }
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
        setState(() {
          receivedData = decodedData;
        });
      });
    } catch (e) {
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

      var services = await device.discoverServices();
      for (var service in services) {
        for (var characteristic in service.characteristics) {
          if (characteristic.properties.notify) {
            await characteristic.setNotifyValue(true);
            characteristic.lastValueStream.listen((value) {
              String decodedData = utf8.decode(value);
              setState(() {
                receivedData = decodedData;
              });
            });
          }
        }
      }
    } catch (e) {
      setState(() {
        isBleConnected = false;
      });
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildDeviceCard("Classic Bluetooth (SPP) Devices", classicDevices,
                _connectToClassicDevice),
            const SizedBox(height: 10),
            _buildDeviceCard("BLE Devices",
                bleDevices.map((r) => r.device).toList(), _connectToBleDevice),
            const SizedBox(height: 10),
            _buildConnectionStatusCard(),
          ],
        ),
      ),
    );
  }

  /// **Device List Wrapped in a Card**
  Widget _buildDeviceCard(
      String title, List devices, Function connectFunction) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black)),
            const SizedBox(height: 10),
            devices.isEmpty
                ? const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Center(
                        child: Text("No devices found",
                            style: TextStyle(color: Colors.grey))),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: devices.length,
                    itemBuilder: (context, index) {
                      var device = devices[index];
                      return Card(
                        elevation: 2,
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        child: ListTile(
                          leading: Icon(Icons.bluetooth,
                              color: primaryDarkBlue, size: 28),
                          title: Text(device.name.isNotEmpty
                              ? device.name
                              : "Unknown Device"),
                          subtitle: Text(device.id.toString()),
                          trailing: ElevatedButton(
                            onPressed: () => connectFunction(device),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryDarkBlue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text("Connect"),
                          ),
                        ),
                      );
                    }),
          ],
        ),
      ),
    );
  }

  /// **Connection Status Wrapped in a Card**
  Widget _buildConnectionStatusCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
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
