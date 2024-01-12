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

  var primary = const Color(0xFF1B1818);
  var secondary = const Color(0xFF1B1818);
  var buttons = const Color(0xFF1B1818);
  var altbuttons = const Color(0xFF1028F1);
  var surface = const Color(0xFFE8EAEF);
  var surface2 = const Color(0xFFA8C2fE);
  var background = const Color(0xFFFFFFFF);
  var shadow = const Color(0xFF1028F1);

  ColorScheme cScheme = ColorScheme(
      primary: primary,
      secondary: secondary,
      tertiary: buttons, //main button color
      tertiaryContainer: altbuttons, //alt button color
      surface: surface, //box gradient 1
      surfaceTint: surface2, //box gradient 2
      background: background,
      error: altbuttons,
      errorContainer: secondary, //menu buttons
      onPrimary: background,
      onSecondary: background,
      onTertiary: surface,
      onTertiaryContainer: surface,
      onSurface: secondary,
      onBackground: secondary,
      onError: secondary,
      onErrorContainer: background,
      shadow: shadow,
      brightness: Brightness.light
  );
  return baseTheme(
    cScheme: cScheme,
    background: background,
    text: secondary
  );
}

ThemeData genDarkTheme (){

  var primary = const Color(0xFF4200FF);
  var secondary = const Color(0xFF0085FF);
  var buttons = const Color(0xFFFEA801);
  var altbuttons = const Color(0xFF4200FF);
  var surface = const Color(0xFF65676C);
  var surface2 = const Color(0xFF866CF1);
  var background = const Color(0xFF000000);
  var shadow = const Color(0xFF866CF1);
  var text = const Color(0xFFF7F1E2);

  ColorScheme cScheme = ColorScheme(
      primary: primary,
      secondary: secondary,
      tertiary: buttons, //main button color
      tertiaryContainer: altbuttons, //alt button color
      surface: surface, //box gradient 1
      surfaceTint: surface2, //box gradient 2
      background: background,
      error: buttons,
      errorContainer: primary, //menu buttons
      onPrimary: text,
      onSecondary: background,
      onTertiary: background,
      onTertiaryContainer: text,
      onSurface: altbuttons,
      onSurfaceVariant: text,
      onBackground: text,
      onError: text,
      onErrorContainer: text,
      shadow: shadow,
      brightness: Brightness.light
  );
  return baseTheme(
      cScheme: cScheme,
      background: background,
      text: text,
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