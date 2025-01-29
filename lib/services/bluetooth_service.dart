import 'dart:async';
import 'dart:convert';
import 'dart:io' show Platform;
import 'dart:typed_data';

import 'package:flutter_blue_plus/flutter_blue_plus.dart' as bt_ble; // BLE
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart'
    as bt_serial; // Classic Bluetooth

class BluetoothService {
  static final BluetoothService _instance = BluetoothService._internal();

  factory BluetoothService() {
    return _instance;
  }

  BluetoothService._internal();

  // Classic Bluetooth (SPP)
  final bt_serial.FlutterBluetoothSerial _bluetoothSerial =
      bt_serial.FlutterBluetoothSerial.instance;
  bt_serial.BluetoothConnection? _classicConnection;
  List<bt_serial.BluetoothDevice> _classicDevices = [];

  // BLE
  List<bt_ble.ScanResult> _bleDevices = [];
  bt_ble.BluetoothDevice? _selectedBleDevice;

  bool _isClassicConnected = false;
  bool _isBleConnected = false;
  bool _isScanning = false;
  String _receivedData = "No data yet";

  final StreamController<List<bt_serial.BluetoothDevice>>
      _classicDevicesStream = StreamController.broadcast();
  final StreamController<List<bt_ble.ScanResult>> _bleDevicesStream =
      StreamController.broadcast();
  final StreamController<String> _dataStream = StreamController.broadcast();
  final StreamController<bool> _connectionStatusStream =
      StreamController.broadcast();

  Stream<List<bt_serial.BluetoothDevice>> get classicDevicesStream =>
      _classicDevicesStream.stream;
  Stream<List<bt_ble.ScanResult>> get bleDevicesStream =>
      _bleDevicesStream.stream;
  Stream<String> get dataStream => _dataStream.stream;
  Stream<bool> get connectionStatusStream => _connectionStatusStream.stream;

  final StreamController<bool> _scanningStream = StreamController.broadcast();
  final StreamController<String> _deviceNameStream =
      StreamController.broadcast();

  Stream<bool> get scanningStream => _scanningStream.stream;
  Stream<String> get deviceNameStream => _deviceNameStream.stream;

  /// **Scan for Bluetooth Devices**
  Future<void> scanDevices() async {
    if (_isScanning) return;
    _isScanning = true;
    _scanningStream.add(true); // Notify UI that scanning has started
    _classicDevices = [];
    _bleDevices = [];

    try {
      if (!await bt_ble.FlutterBluePlus.isSupported ||
          (await bt_ble.FlutterBluePlus.adapterState.first) !=
              bt_ble.BluetoothAdapterState.on) {
        print("❌ Bluetooth is OFF. Cannot start scanning.");
        _isScanning = false;
        _scanningStream.add(false);
        return;
      }

      await bt_ble.FlutterBluePlus.stopScan();
      await Future.delayed(const Duration(milliseconds: 500));

      // Scan for Classic Bluetooth devices (SPP)
      if (Platform.isAndroid || Platform.isMacOS) {
        List<bt_serial.BluetoothDevice> bondedDevices =
            await _bluetoothSerial.getBondedDevices();

        // 🔹 Filter devices: ESP, Arduino, HC-05, HC-08, MacBook
        _classicDevices = bondedDevices.where((device) {
          final name = device.name?.toLowerCase() ?? "";
          return name.contains('esp') ||
              name.contains('arduino') ||
              name.contains('hc-05') ||
              name.contains('hc-08') ||
              name.contains('macbook');
        }).toList();

        _classicDevicesStream.add(_classicDevices);
      }

      // Scan for BLE devices
      bt_ble.FlutterBluePlus.startScan(timeout: const Duration(seconds: 5));
      bt_ble.FlutterBluePlus.scanResults
          .listen((List<bt_ble.ScanResult> results) {
        _bleDevices = results.where((r) {
          final name = r.device.platformName.toLowerCase();
          final serviceUuids = r.advertisementData.serviceUuids
              .map((uuid) => uuid.toString())
              .toList();

          return name.contains('esp') ||
              name.contains('arduino') ||
              name.contains('hc-08') ||
              name.contains('macbook') ||
              serviceUuids.contains(
                  "0000ffe0-0000-1000-8000-00805f9b34fb"); // Common microcontroller UUID
        }).toList();

        _bleDevicesStream.add(_bleDevices);
      });

      print("🔍 Scanning for Microcontrollers & MacBook...");
    } catch (e) {
      print("❌ Error scanning: $e");
    } finally {
      _isScanning = false;
      _scanningStream.add(false); // Notify UI that scanning has stopped
    }
  }

  /// **Disconnect from Both Classic and BLE**
  void disconnect() {
    if (_isClassicConnected) {
      disconnectClassic();
    }
    if (_isBleConnected) {
      disconnectBle();
    }
  }

  /// **Connect to Classic Bluetooth Device**
  Future<void> connectToClassicDevice(bt_serial.BluetoothDevice device) async {
    try {
      _classicConnection =
          await bt_serial.BluetoothConnection.toAddress(device.address);
      _isClassicConnected = true;

      // 🔹 Update the device name
      _deviceNameStream.add((device.name != null && device.name!.isNotEmpty)
          ? device.name!
          : "Unknown Device");

      _classicConnection!.input!.listen((Uint8List data) {
        try {
          String decodedData = utf8.decode(data);
          _dataStream.add(decodedData);
        } catch (e) {
          print("⚠️ Classic Bluetooth Data Decode Error: $e");
        }
      });

      _connectionStatusStream.add(true);
    } catch (e) {
      _isClassicConnected = false;
      _connectionStatusStream.add(false);
      print("❌ Failed to connect to Classic Bluetooth: $e");
    }
  }

  /// **Connect to BLE Device**
  Future<void> connectToBleDevice(bt_ble.BluetoothDevice device) async {
    try {
      await device.connect();
      _isBleConnected = true;
      _selectedBleDevice = device;

      // 🔹 Update the device name
      _deviceNameStream.add(device.platformName.isNotEmpty
          ? device.platformName
          : "Unknown Device");

      var services = await device.discoverServices();
      for (var service in services) {
        for (var characteristic in service.characteristics) {
          if (characteristic.properties.notify) {
            await characteristic.setNotifyValue(true);
            characteristic.lastValueStream.listen((value) {
              try {
                String decodedData = utf8.decode(value);
                _dataStream.add(decodedData);
              } catch (e) {
                print("⚠️ BLE Data Decode Error: $e");
              }
            });
          }
        }
      }

      _connectionStatusStream.add(true);
    } catch (e) {
      _isBleConnected = false;
      _connectionStatusStream.add(false);
      print("❌ Failed to connect to BLE: $e");
    }
  }

  /// **Disconnect from Classic Bluetooth**
  void disconnectClassic() {
    _classicConnection?.finish();
    _isClassicConnected = false;
    _connectionStatusStream.add(false);

    // 🔹 Reset device name and received data
    _deviceNameStream.add("None");
    _dataStream.add("No data yet");
  }

  /// **Disconnect from BLE**
  void disconnectBle() {
    _selectedBleDevice?.disconnect();
    _isBleConnected = false;
    _connectionStatusStream.add(false);

    // 🔹 Reset device name and received data
    _deviceNameStream.add("None");
    _dataStream.add("No data yet");
  }
}
