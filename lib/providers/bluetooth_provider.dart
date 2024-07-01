import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BluetoothProvider with ChangeNotifier {
  final List<BluetoothDevice> _devices = [];
  static const String _keyPrefix = 'device_';

  BluetoothProvider() {
    _initDevicesFromSharedPreferences();
  }

  List<BluetoothDevice> get devices {
    return [..._devices];
  }

  Future<void> scanDevices() async {
    var status = await Permission.bluetooth.status;
    if (!status.isGranted) {
      print('Bluetooth permission not granted');
      status = await Permission.bluetooth.request();
    }

    if (status.isGranted) {
      print('Scanning for devices...');
      FlutterBluePlus.startScan(timeout: Duration(seconds: 10));

      FlutterBluePlus.scanResults.listen((results) {
        print('Found ${results.length} devices');
        _devices.clear();
        _devices.addAll(results.map((result) => result.device));
        _saveDevicesToSharedPreferences();
      });
      notifyListeners();
    }
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
    int deviceIndex = await _getNextDeviceIndex(prefs);
    for (int i = 0; i < deviceIndex; i++) {
      String? deviceId = prefs.getString('$_keyPrefix${i}_id');
      if (deviceId != null) {
        BluetoothDevice device =
            BluetoothDevice(remoteId: DeviceIdentifier(deviceId));
        _devices.add(device);
      }
    }
  }

  Future<void> _saveDevicesToSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    Set<String> savedDeviceIds =
        prefs.getKeys().where((key) => key.startsWith(_keyPrefix)).toSet();

    for (int i = 0; i < _devices.length; i++) {
      BluetoothDevice device = _devices[i];
      String deviceIdKey = '$_keyPrefix${i}_id';
      await prefs.setString(deviceIdKey, device.remoteId.id);
      savedDeviceIds.remove(deviceIdKey);
    }

    for (String deviceIdKey in savedDeviceIds) {
      await prefs.remove(deviceIdKey);
    }
  }

  static Future<int> _getNextDeviceIndex(SharedPreferences prefs) async {
    int deviceIndex = 0;
    while (prefs.containsKey('$_keyPrefix${deviceIndex}_id')) {
      deviceIndex++;
    }
    return deviceIndex;
  }
}
