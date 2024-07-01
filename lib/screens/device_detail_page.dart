import 'package:bluetooth_finder/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class DeviceDetail extends StatelessWidget {
  const DeviceDetail({
    super.key,
    required this.device,
  });

  final BluetoothDevice device;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(device.remoteId.str),
      ),
      body: ListView(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.65,
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: kPrimaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: ListView(
              physics: const NeverScrollableScrollPhysics(),
              children: [
                ListTile(
                  title: Text('Device ID'),
                  subtitle: Text(device.remoteId.str),
                ),
                ListTile(
                  title: Text('Platform Name'),
                  subtitle: Text(device.platformName),
                ),
                ListTile(
                  title: Text('Device Type'),
                  subtitle: Text(device.advName.toString()),
                ),
                ListTile(
                  title: Text('Device Connected'),
                  subtitle: Text(device.isConnected.toString()),
                ),
                ListTile(
                  title: Text('Device Services'),
                  subtitle: Text(device.services.toString()),
                ),
              ],
            ),
          ),
          //connect and disconnect buttons in a row
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  device.connect();
                },
                child: Text('Connect'),
              ),
              ElevatedButton(
                onPressed: () {
                  device.disconnect();
                },
                child: Text('Disconnect'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
