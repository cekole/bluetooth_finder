import 'package:bluetooth_finder/widgets/previously_connected_devices.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:bluetooth_finder/constants/colors.dart';
import 'package:bluetooth_finder/providers/bluetooth_provider.dart';
import 'package:bluetooth_finder/screens/device_detail_page.dart';
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
            PreviouslyConnectedDevices(),
            SizedBox(height: MediaQuery.of(context).size.height / 12),
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
                        device.platformName.isEmpty
                            ? 'Unknown Device'
                            : device.platformName,
                      ),
                      subtitle: Text(device.remoteId.toString()),
                    );
                  },
                );
              },
            ),
            SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: ElevatedButton(
                onPressed: () {
                  _isScanning
                      ? Provider.of<BluetoothProvider>(context, listen: false)
                          .stopScan()
                      : Provider.of<BluetoothProvider>(context, listen: true)
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
