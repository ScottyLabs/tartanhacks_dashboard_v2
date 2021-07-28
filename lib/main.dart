import 'package:flutter/material.dart';
import 'pages/login.dart';
import 'pages/home.dart';
import 'pages/splash.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TartanHacks Dashboard',
      theme: ThemeData(
        fontFamily: 'TerminalGrotesque',
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(),
    );
  }
}
