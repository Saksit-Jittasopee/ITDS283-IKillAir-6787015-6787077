import 'package:flutter/material.dart';
import 'package:ikillair/pages/createaccount.dart';
import 'package:ikillair/pages/login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IKillAir App',
      home: const LoginPage(),
    );
  }
}