import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:bluetooth_finder/constants/colors.dart';
import 'package:bluetooth_finder/providers/bluetooth_provider.dart';
import 'package:bluetooth_finder/screens/device_detail_page.dart';
import 'package:bluetooth_finder/screens/previously_connected_page.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  bool _isScanning = false;
  late AnimationController _animationController;
  late ColorTween _colorTween;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1, milliseconds: 500),
    )..repeat(reverse: true);
    _colorTween = ColorTween(begin: Colors.black, end: kPrimaryColor);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Bluetooth Devices'),
      ),
      body: SafeArea(
        child: ListView(
          children: [
            // Previously connected devices
            Container(
              decoration: BoxDecoration(
                color: kPrimaryColor.withOpacity(0.1),
              ),
              margin: const EdgeInsets.all(16),
              child: ExpansionTile(
                title: Text('Previously Connected Devices'),
                children: [
                  ...Provider.of<BluetoothProvider>(context)
                      .devices
                      .take(3)
                      .map(
                        (device) => ListTile(
                          trailing: Icon(Icons.info_outline),
                          onTap: () {
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                transitionDuration:
                                    const Duration(milliseconds: 250),
                                pageBuilder: (context, _, __) => DeviceDetail(
                                  device: device,
                                ),
                                transitionsBuilder:
                                    (context, animation, _, child) {
                                  return FadeTransition(
                                    opacity: animation,
                                    child: child,
                                  );
                                },
                              ),
                            );
                          },
                          title: Text(device.remoteId.str),
                        ),
                      )
                      .toList(),
                  ListTile(
                    trailing: Text(
                      'View All',
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          transitionDuration: const Duration(milliseconds: 250),
                          pageBuilder: (context, _, __) =>
                              PreviouslyConnectedPage(),
                          transitionsBuilder: (context, animation, _, child) {
                            return FadeTransition(
                              opacity: animation,
                              child: child,
                            );
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height / 12),
            // Scanning and discovered devices
            StreamBuilder<List<ScanResult>>(
              stream: Provider.of<BluetoothProvider>(context).getScanResults(),
              builder: (context, snapshot) {
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: _isScanning
                        ? AnimatedBuilder(
                            animation: _animationController,
                            builder: (context, child) {
                              final color =
                                  _colorTween.evaluate(_animationController);
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.bluetooth_connected_rounded,
                                    color: color,
                                    size: MediaQuery.of(context).size.width / 4,
                                  ),
                                  SizedBox(height: 16),
                                  Text('Scanning for devices...'),
                                ],
                              );
                            },
                          )
                        : Column(
                            children: [
                              Icon(
                                Icons.bluetooth_connected_rounded,
                                color: kPrimaryColor,
                                size: MediaQuery.of(context).size.width / 4,
                              ),
                            ],
                          ),
                  );
                }
                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final device = snapshot.data![index].device;
                    return ListTile(
                      onTap: () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            transitionDuration:
                                const Duration(milliseconds: 250),
                            pageBuilder: (context, _, __) => DeviceDetail(
                              device: device,
                            ),
                            transitionsBuilder: (context, animation, _, child) {
                              return FadeTransition(
                                opacity: animation,
                                child: child,
                              );
                            },
                          ),
                        );
                      },
                      title: Text(
                        device.name.isEmpty ? 'Unknown Device' : device.name,
                      ),
                      subtitle: Text(device.id.toString()),
                    );
                  },
                );
              },
            ),
            SizedBox(height: 16),
            // Scan control button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: ElevatedButton(
                onPressed: () {
                  _isScanning
                      ? Provider.of<BluetoothProvider>(context, listen: false)
                          .stopScan()
                      : Provider.of<BluetoothProvider>(context, listen: false)
                          .scanDevices();

                  setState(() {
                    _isScanning = !_isScanning;
                  });
                },
                child: Text(_isScanning ? 'Stop Scanning' : 'Start Scanning'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
