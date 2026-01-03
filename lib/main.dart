import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'ui/screen/welcome_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return DevicePreview(
      // Set to true to enable device preview
      builder: (context) => MaterialApp(
        useInheritedMediaQuery: true,
        debugShowCheckedModeBanner: false,
        title: 'Rentalange',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const WelcomeScreen(),
      ),
    );
  }
}
