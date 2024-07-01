import 'package:bluetooth_finder/constants/colors.dart';
import 'package:bluetooth_finder/providers/bluetooth_provider.dart';
import 'package:bluetooth_finder/screens/device_detail_page.dart';
import 'package:flutter/material.dart';
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
        child: ListView(
          children: [
            //Previously connected devices
            Container(
              margin: const EdgeInsets.all(16),
              child: ListView.separated(
                shrinkWrap: true,
                separatorBuilder: (context, index) => const Divider(),
                itemCount:
                    Provider.of<BluetoothProvider>(context).devices.length,
                itemBuilder: (context, index) => ListTile(
                  title: Text(
                    Provider.of<BluetoothProvider>(context)
                        .devices[index]
                        .remoteId
                        .str,
                  ),
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
