import 'package:bluetooth_finder/providers/bluetooth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final bluetoothData =
              Provider.of<BluetoothProvider>(context, listen: false);
          bluetoothData.startScan();
          //get the list of bluetooth devices
          var devices = bluetoothData.getScanResults();
          print(devices);
        },
        child: Icon(Icons.wifi_tethering_rounded),
        backgroundColor: Colors.white,
      ),
      appBar: AppBar(
        centerTitle: true,
        title: Text('Bluetooth Devices'),
      ),
      body: StreamBuilder(
        stream: Provider.of<BluetoothProvider>(context).getScanResults(),
        builder: (context, snapshot) {
          print(snapshot.data);
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.builder(
            itemCount: snapshot.data?.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(
                  snapshot.data![index].device.platformName.toString(),
                ),
                subtitle:
                    Text(snapshot.data![index].device.remoteId.toString()),
              );
            },
          );
        },
      ),
    );
  }
}
