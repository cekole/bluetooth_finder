import 'package:bluetooth_finder/constants/colors.dart';
import 'package:bluetooth_finder/providers/bluetooth_provider.dart';
import 'package:bluetooth_finder/screens/device_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:provider/provider.dart';

class PreviouslyConnectedPage extends StatelessWidget {
  const PreviouslyConnectedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Previously Connected Devices'),
      ),
      body: SafeArea(
        child: Consumer<BluetoothProvider>(
          builder: (context, bluetoothProvider, _) {
            List<BluetoothDevice> devices = bluetoothProvider.devices;
            return ListView.separated(
              padding: const EdgeInsets.all(16),
              separatorBuilder: (context, index) => const Divider(),
              itemCount: devices.length,
              itemBuilder: (context, index) => ListTile(
                title: Text(devices[index].remoteId.str),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      transitionDuration: const Duration(milliseconds: 250),
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          DeviceDetail(
                        device: Provider.of<BluetoothProvider>(context)
                            .devices[index],
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
              ),
            );
          },
        ),
      ),
    );
  }
}
