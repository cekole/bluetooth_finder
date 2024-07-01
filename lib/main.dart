import 'package:bluetooth_finder/constants/colors.dart';
import 'package:bluetooth_finder/providers/bluetooth_provider.dart';
import 'package:bluetooth_finder/screens/home_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => BluetoothProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Bluetooth App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: kPrimaryColor),
          useMaterial3: true,
          appBarTheme: AppBarTheme(
            backgroundColor: kPrimaryColor.withOpacity(0.5),
            foregroundColor: Colors.white,
          ),
        ),
        routes: {
          '/': (context) => HomePage(),
        },
      ),
    );
  }
}
