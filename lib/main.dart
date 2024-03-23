import 'package:flutter/material.dart';
import 'package:technopartner/ui/home.dart';
import 'package:technopartner/ui/login.dart';
import 'package:technopartner/ui/menu.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Frontend Test',
        theme: ThemeData(
          useMaterial3: true,
        ),
        home: LoginScreen());
  }
}
