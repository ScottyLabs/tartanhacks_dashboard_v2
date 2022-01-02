import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

ThemeData baseTheme({ColorScheme cScheme, Color background, Color text}) {
  return ThemeData(
      fontFamily: 'Poppins',
      colorScheme: cScheme,
      scaffoldBackgroundColor: background,
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
  );
}

ThemeData genLightTheme (){
  var primary = Color(0xFFF6C744);
  var primarytrans = Color(0x87F6C744);
  var secondary = Color(0xFFF68F44);
  var secondarytrans = Color(0x87F68F44);
  var accent = Color(0xFFAA5418);
  var surface = Color(0xFFFFE3E3);
  var background = Color(0xFFFFFFFF);

  ColorScheme cScheme = ColorScheme(
      primary: primary,
      primaryVariant: primarytrans,
      secondary: secondary,
      secondaryVariant: secondarytrans,
      surface: surface,
      background: background,
      error: secondarytrans, //shadows
      onPrimary: background,
      onSecondary: background,
      onSurface: accent,
      onBackground: accent,
      onError: secondary, //menu buttons
      brightness: Brightness.light
  );
  return baseTheme(
    cScheme: cScheme,
    background: background,
    text: accent
  );
}

ThemeData genDarkTheme (){
  var primary = Color(0xFFF6C744);
  var primarytrans = Color(0x87F6C744);
  var secondary = Color(0xFFF68F44);
  var secondarytrans = Color(0x87F68F44);
  var accent = Color(0xFF78524a);
  var surface = Color(0xFF626262);
  var background = Color(0xFF000000);
  var text = Color(0xFFFFFFFF);
  var shadow = Color(0x87473F3C);

  ColorScheme cScheme = ColorScheme(
      primary: primary,
      primaryVariant: primarytrans,
      secondary: secondary,
      secondaryVariant: secondarytrans,
      surface: accent,
      background: surface,
      error: shadow, //shadows
      onPrimary: background,
      onSecondary: text,
      onSurface: text,
      onBackground: secondary,
      onError: accent, //menu buttons
      brightness: Brightness.light
  );
  return baseTheme(
      cScheme: cScheme,
      background: background,
      text: text
  );
}

ThemeData lightTheme = genLightTheme();
ThemeData darkTheme = genDarkTheme();

class ThemeChanger extends ChangeNotifier {
  ThemeData _themeData;
  ThemeChanger(this._themeData);

  get getTheme => _themeData;
  void setTheme(ThemeData theme) {
    _themeData = theme;
    notifyListeners();
  }
}