import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


ThemeData baseTheme({ColorScheme cScheme, Color background, Color text}) {
  return ThemeData(
      fontFamily: 'Aktiv Grotesk',
      colorScheme: cScheme,
      scaffoldBackgroundColor: background,
      accentColor: text,
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
          errorStyle: TextStyle(color: cScheme.secondary),
          isDense: true,
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 2.0, color: text),
              borderRadius: BorderRadius.all(Radius.circular(15.0))
          ),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 2.0, color: text),
              borderRadius: BorderRadius.all(Radius.circular(15.0))
          ),
          disabledBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 2.0, color: text.withAlpha(87)),
              borderRadius: BorderRadius.all(Radius.circular(15.0))
          ),
          errorBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 2.0, color: text),
              borderRadius: BorderRadius.all(Radius.circular(15.0))
          ),
        focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 2.0, color: text),
            borderRadius: BorderRadius.all(Radius.circular(15.0))
        ),
      )
  );
}

ThemeData genLightTheme (){

  var primary = Color(0xFFFFC738);
  var primarytrans = Color(0xFFDB4D20); // background curves gradient
  var secondary = Color(0xFFFFC738);
  var secondarytrans = Color(0xFFFFE8AC); // box gradient 2
  var accent = Color(0xFFDB4D20);
  var surface = Color(0xFFFFFFFF);
  var background = Color(0xFFFFFFFF);

  var shadow = Color(0x30473F3C);
  ColorScheme cScheme = ColorScheme(
      primary: primary,
      primaryVariant: secondarytrans,
      secondary: secondary,
      secondaryVariant: primarytrans, // background curves gradient

      surface: surface, //box gradient 1
      background: secondarytrans, //box gradient 2
      error: accent, //menu buttons
      onPrimary: background,
      onSecondary: surface,
      onSurface: accent,
      onBackground: shadow, //shadows
      onError: background,
      brightness: Brightness.light
  );
  return baseTheme(
    cScheme: cScheme,
    background: background,
    text: accent
  );
}

ThemeData genDarkTheme (){

  var primary = Color(0xFFFFC738);
  var primarytrans = Color(0xFF7B6368); // box gradient 2
  var secondary = Color(0xFFDB4D20);
  var secondarytrans = Color(0xFFDB4D20); // background curves gradient
  var accent = Color(0xFF78524a);
  var surface = Color(0xFF07054C);
  var background = Color(0xFF07054C);
  var text = Color(0xFFFFFFFF);
  var shadow = Color(0x87473F3C);

  ColorScheme cScheme = ColorScheme(
      primary: primary,
      primaryVariant: primarytrans,
      secondary: secondary,
      secondaryVariant: secondarytrans, // background curves gradient

      surface: surface, //box gradient 1
      background: primarytrans, //box gradient 2
      error: surface, // menu buttons
      onPrimary: background,
      onSecondary: text,
      onSurface: primary,
      onBackground: shadow, //shadows
      onError: primary,
      brightness: Brightness.dark
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