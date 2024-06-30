import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BluetoothProvider with ChangeNotifier {
  void startScan() {
    FlutterBluePlus.startScan(timeout: Duration(seconds: 10));

    FlutterBluePlus.stopScan();
    notifyListeners();
  }

  //get scan results
  Stream<List<ScanResult>> getScanResults() {
    return FlutterBluePlus.scanResults;
  }

  //get the list of bluetooth devices
  List<BluetoothDevice> getDevices() {
    return FlutterBluePlus.connectedDevices;
  }
}
