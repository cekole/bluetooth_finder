import 'package:bluetooth_finder/constants/colors.dart';
import 'package:bluetooth_finder/providers/bluetooth_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:provider/provider.dart';

class DeviceDetail extends StatefulWidget {
  const DeviceDetail({
    super.key,
    required this.device,
  });

  final BluetoothDevice device;

  @override
  State<DeviceDetail> createState() => _DeviceDetailState();
}

class _DeviceDetailState extends State<DeviceDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.device.remoteId.str),
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
                  title: Text('Device Address'),
                  subtitle: Text(widget.device.remoteId.str),
                ),
                ListTile(
                  title: Text('Platform Name'),
                  subtitle: Text(widget.device.platformName.isEmpty
                      ? 'Unknown'
                      : widget.device.platformName),
                ),
                ListTile(
                  title: Text('Device Connection State'),
                  subtitle: Text(widget.device.isConnected
                      ? 'Connected'
                      : 'Not Connected'),
                ),
                widget.device.advName.isNotEmpty
                    ? ListTile(
                        title: Text('Device Advertisement Data'),
                        subtitle: Text(widget.device.advName.toString()),
                      )
                    : const SizedBox.shrink(),
              ],
            ),
          ),
          Column(
            children: [
              Visibility(
                visible: !widget.device.isConnected,
                child: ElevatedButton(
                  onPressed: () async {
                    await widget.device.connect();
                    if (widget.device.isConnected) {
                      showCupertinoDialog(
                        context: context,
                        builder: (context) => CupertinoAlertDialog(
                          title: Text('Connection Successful'),
                          content: Text(
                              'Connected to ${widget.device.platformName.isEmpty ? 'Unknown Device' : widget.device.platformName}'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Provider.of<BluetoothProvider>(
                                  context,
                                  listen: false,
                                ).addDevice(widget.device);
                                Navigator.pop(context);
                                Navigator.pop(context);
                              },
                              child: Text('OK'),
                            ),
                          ],
                        ),
                      );
                    } else {
                      showCupertinoDialog(
                        context: context,
                        builder: (context) => CupertinoAlertDialog(
                          title: Text('Connection Failed'),
                          content: Text(
                              'Failed to connect to ${widget.device.platformName.isEmpty ? 'Unknown Device' : widget.device.platformName}'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('OK'),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                  child: Text('Connect'),
                ),
              ),
              SizedBox(height: 16),
              Visibility(
                visible: widget.device.isConnected,
                child: ElevatedButton(
                  onPressed: () async {
                    await widget.device.disconnect();
                    if (!widget.device.isConnected) {
                      showCupertinoDialog(
                        context: context,
                        builder: (context) => CupertinoAlertDialog(
                          title: Text('Disconnection Successful'),
                          content: Text(
                              'Disconnected from ${widget.device.platformName}'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                Navigator.pop(context);
                              },
                              child: Text('OK'),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                  child: Text('Disconnect'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
