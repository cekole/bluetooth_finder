import 'package:bluetooth_finder/constants/colors.dart';
import 'package:bluetooth_finder/providers/bluetooth_provider.dart';
import 'package:bluetooth_finder/screens/device_detail_page.dart';
import 'package:bluetooth_finder/screens/previously_connected_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PreviouslyConnectedDevices extends StatelessWidget {
  const PreviouslyConnectedDevices({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: kPrimaryColor.withOpacity(0.1),
      ),
      margin: const EdgeInsets.all(16),
      child: ExpansionTile(
        title: Text('Previously Connected Devices'),
        children: [
          ...Provider.of<BluetoothProvider>(context)
              .previouslyConnectedDevices
              .take(3)
              .map(
                (device) => ListTile(
                  trailing: Icon(Icons.info_outline),
                  onTap: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        transitionDuration: const Duration(milliseconds: 250),
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
                  title: Text(device.platformName == ''
                      ? 'Unknown Device'
                      : device.platformName),
                  subtitle: Text(
                    device.remoteId.toString(),
                  ),
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
                  pageBuilder: (context, _, __) => PreviouslyConnectedPage(),
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
    );
  }
}
