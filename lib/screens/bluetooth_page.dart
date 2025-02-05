import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart' as bt_ble;
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart'
    as bt_serial;
import 'package:google_fonts/google_fonts.dart';

import '../services/bluetooth_service.dart';
import '../utils/color_utils.dart';

class BluetoothPage extends StatefulWidget {
  const BluetoothPage({super.key});

  @override
  BluetoothPageState createState() => BluetoothPageState();
}

class BluetoothPageState extends State<BluetoothPage> {
  late final BluetoothService _bluetoothService;

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
            StreamBuilder<bool>(
              stream: _bluetoothService.scanningStream,
              builder: (context, snapshot) {
                bool isScanning = snapshot.data ?? false;
                return isScanning
                    ? const Center(child: CircularProgressIndicator())
                    : const SizedBox();
              },
            ),

            // Use Expanded to prevent overflow
            Expanded(
              child: ListView(
                children: [
                  StreamBuilder<List<bt_serial.BluetoothDevice>>(
                    stream: _bluetoothService.classicDevicesStream,
                    builder: (context, snapshot) {
                      return _buildDeviceCard(
                          "Classic Bluetooth (SPP) Devices",
                          snapshot.data ?? [],
                          _bluetoothService.connectToClassicDevice);
                    },
                  ),
                  const SizedBox(height: 10),
                  StreamBuilder<List<bt_ble.ScanResult>>(
                    stream: _bluetoothService.bleDevicesStream,
                    builder: (context, snapshot) {
                      return _buildDeviceCard(
                          "BLE Devices",
                          snapshot.data?.map((r) => r.device).toList() ?? [],
                          _bluetoothService.connectToBleDevice);
                    },
                  ),
                  const SizedBox(height: 10),
                  _buildConnectionStatusCard(),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _bluetoothService.scanDevices,
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
                StreamBuilder<String>(
                  stream: _bluetoothService.dataStream,
                  builder: (context, snapshot) {
                    String receivedData = snapshot.data ?? "No data yet";
                    return Text("Received Data: $receivedData",
                        style: GoogleFonts.poppins(
                            fontSize: 14, fontWeight: FontWeight.w500),
                        textAlign: TextAlign.center);
                  },
                ),
                const SizedBox(height: 20),
                if (isConnected)
                  ElevatedButton(
                    onPressed: _bluetoothService.disconnect,
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent),
                    child: const Text("Disconnect"),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
