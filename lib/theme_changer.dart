import 'package:flutter/material.dart';


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
              borderRadius: const BorderRadius.all(Radius.circular(15.0))
          ),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 2.0, color: text),
              borderRadius: const BorderRadius.all(Radius.circular(15.0))
          ),
          disabledBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 2.0, color: text.withAlpha(87)),
              borderRadius: const BorderRadius.all(Radius.circular(15.0))
          ),
          errorBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 2.0, color: text),
              borderRadius: const BorderRadius.all(Radius.circular(15.0))
          ),
        focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 2.0, color: text),
            borderRadius: const BorderRadius.all(Radius.circular(15.0))
        ),
      )
  );
}

ThemeData genLightTheme (){

  var primary = const Color(0xFF6E9AFD);
  var primarytrans = const Color(0xFF4200FF); // background curves gradient
  var secondary = const Color(0xFF4200FF);
  var secondarytrans = const Color(0xFF6E9AFD); // box gradient 2
  var accent = const Color(0xFFFEA801);
  var surface = const Color(0xFFF7F1E2);
  var background = const Color(0xFFF7F1E2);

  var shadow = const Color(0x30473F3C);
  ColorScheme cScheme = ColorScheme(
      primary: primary,
      primaryVariant: secondarytrans,
      secondary: secondary,
      secondaryVariant: primarytrans, // background curves gradient
      tertiary: accent,
      surface: surface, //box gradient 1
      background: secondarytrans, //box gradient 2
      error: secondary, //menu buttons
      onPrimary: background,
      onSecondary: surface,
      onTertiary: surface,
      onSurface: secondary,
      onBackground: shadow, //shadows
      onError: background,
      brightness: Brightness.light
  );
  return baseTheme(
    cScheme: cScheme,
    background: background,
    text: secondary
  );
}

ThemeData genDarkTheme (){

  var primary = const Color(0xFFFFC738);
  var primarytrans = const Color(0xFF7B6368); // box gradient 2
  var secondary = const Color(0xFFDB4D20);
  var secondarytrans = const Color(0xFFDB4D20); // background curves gradient
  var surface = const Color(0xFF07054C);
  var background = const Color(0xFF07054C);
  var text = const Color(0xFFFFFFFF);
  var shadow = const Color(0x87473F3C);

  ColorScheme cScheme = ColorScheme(
      primary: primary,
      primaryVariant: primarytrans,
      secondary: secondary,
      secondaryVariant: secondarytrans, // background curves gradient
      tertiary: primary,
      surface: surface, //box gradient 1
      background: primarytrans, //box gradient 2
      error: surface, // menu buttons
      onPrimary: background,
      onSecondary: text,
      onTertiary: background,
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