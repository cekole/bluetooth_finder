import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BluetoothProvider with ChangeNotifier {
  final List<BluetoothDevice> _devices = [];
  final List<BluetoothDevice> _previouslyConnectedDevices = [];
  static const String _keyPrefix = 'device_';

  BluetoothProvider() {
    _initDevicesFromSharedPreferences();
  }

  List<BluetoothDevice> get devices {
    return [..._devices];
  }

  List<BluetoothDevice> get previouslyConnectedDevices {
    return [..._previouslyConnectedDevices];
  }

  void addDevice(BluetoothDevice device) {
    if (!_previouslyConnectedDevices.contains(device)) {
      _previouslyConnectedDevices.add(device);
      SharedPreferences.getInstance().then((prefs) {
        prefs.setString(
          '$_keyPrefix${_previouslyConnectedDevices.length - 1}_id',
          device.remoteId.str,
        );
      });
    }
    notifyListeners();
  }

  Future<void> scanDevices() async {
    print('Scanning for devices...');
    FlutterBluePlus.startScan(timeout: Duration(seconds: 10));

    FlutterBluePlus.scanResults.listen((results) {
      for (ScanResult result in results) {
        BluetoothDevice device =
            BluetoothDevice(remoteId: result.device.remoteId);
        if (!_devices.contains(device)) {
          _devices.add(device);
        }
      }
      notifyListeners();
    });
  }

  void stopScan() {
    FlutterBluePlus.stopScan();
    notifyListeners();
  }

  Stream<List<ScanResult>> getScanResults() {
    return FlutterBluePlus.scanResults;
  }

  List<BluetoothDevice> getConnectedDevices() {
    return FlutterBluePlus.connectedDevices;
  }

  Future<void> _initDevicesFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.getKeys().where((key) => key.startsWith(_keyPrefix)).forEach((key) {
      String id = prefs.getString(key)!;
      _previouslyConnectedDevices
          .add(BluetoothDevice(remoteId: DeviceIdentifier(id)));
    });
    notifyListeners();
  }
}
