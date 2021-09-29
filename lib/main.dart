import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'pages/home.dart';
import 'pages/login.dart';
import 'pages/forgot.dart';
import 'pages/project_submission.dart';
import 'pages/sponsors.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  var primary = Color(0xFFF6C744);
  var primarytrans = Color(0x87F6C744);
  var secondary = Color(0xFFF68F44);
  var secondarytrans = Color(0x87F68F44);
  var text = Color(0xFFAA5418);
  var surface = Color(0xFFFFE3E3);
  var background = Color(0xFFFFFFFF);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    return MaterialApp(
      title: 'TartanHacks Dashboard',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Poppins',
        colorScheme: ColorScheme(
          primary: primary,
          primaryVariant: primarytrans,
          secondary: secondary,
          secondaryVariant: secondarytrans,
          surface: surface,
          background: background,
          error: secondary,
          onPrimary: background,
          onSecondary: background,
          onSurface: text,
          onBackground: text,
          onError: background,
          brightness: Brightness.light
        ),
        textTheme: TextTheme(
          headline1: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold, color: text),
          headline2: TextStyle(fontSize: 26.0, fontWeight: FontWeight.bold, color: text),
          headline3: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold, color: text),
          headline4: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: text),
          bodyText1: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w600, color: background),
          bodyText2: TextStyle(fontSize: 16.0, color: text),
        ),
        inputDecorationTheme: InputDecorationTheme(
          labelStyle: TextStyle(color: text, fontWeight: FontWeight.bold),
          isDense: true,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 2.0, color: text),
            borderRadius: BorderRadius.all(Radius.circular(15.0))
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 2.0, color: text),
            borderRadius: BorderRadius.all(Radius.circular(15.0))
          )
        )
      ),
      home: Sponsors(),
    );
  }
}
