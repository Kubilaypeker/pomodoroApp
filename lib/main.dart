import 'package:flutter/material.dart';
import 'package:pomodoroapp/screens/homeScreen.dart';
import 'package:pomodoroapp/screens/timeoutScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pomodoro App',
      home: homeScreen(),
    );
  }
}
