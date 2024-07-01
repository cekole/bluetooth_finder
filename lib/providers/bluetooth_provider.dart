import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';

class BluetoothProvider with ChangeNotifier {
  final _devices = [
    BluetoothDevice(
      remoteId: DeviceIdentifier('test_device_id_1'),
    ),
    BluetoothDevice(
      remoteId: DeviceIdentifier('test_device_id_2'),
    ),
    BluetoothDevice(
      remoteId: DeviceIdentifier('test_device_id_3'),
    ),
    BluetoothDevice(
      remoteId: DeviceIdentifier('test_device_id_4'),
    ),
    BluetoothDevice(
      remoteId: DeviceIdentifier('test_device_id_5'),
    ),
    BluetoothDevice(
      remoteId: DeviceIdentifier('test_device_id_6'),
    ),
    BluetoothDevice(
      remoteId: DeviceIdentifier('test_device_id_7'),
    ),
    BluetoothDevice(
      remoteId: DeviceIdentifier('test_device_id_8'),
    ),
    BluetoothDevice(
      remoteId: DeviceIdentifier('test_device_id_9'),
    ),
  ];

  List<BluetoothDevice> get devices {
    return [..._devices];
  }

  Future<void> scanDevices() async {
    var status = await Permission.bluetooth.status;
    if (!status.isGranted) {
      status = await Permission.bluetooth.request();
    }

    if (status.isGranted) {
      print('Scanning for devices...');
      FlutterBluePlus.startScan(timeout: Duration(seconds: 10));

      FlutterBluePlus.scanResults.listen((results) {
        print('Found ${results.length} devices');
        for (var result in results) {
          print('Device found: ${result.device.name}');
        }
      });

      FlutterBluePlus.stopScan();
      notifyListeners();
    }
  }

  Stream<List<ScanResult>> getScanResults() {
    return FlutterBluePlus.scanResults;
  }

  List<BluetoothDevice> getDevices() {
    return FlutterBluePlus.connectedDevices;
  }
}
