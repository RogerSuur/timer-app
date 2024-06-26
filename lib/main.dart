import 'package:boxing_timer_app/setupTraining.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fitness app',
      theme: ThemeData(
        fontFamily: 'OpenSans',
        colorScheme: ColorScheme.light(
            onPrimary: Colors.blue, onSecondary: Colors.black),
        useMaterial3: true,
      ),
      home: SetupTraining(),
    );
  }
}
