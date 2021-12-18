import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:thdapp/providers/check_in_items_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'pages/login.dart';
import 'theme_changer.dart';

void main() => runApp(
    MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => CheckInItemsModel()),
          ChangeNotifierProvider(create: (_) => ThemeChanger(lightTheme)),
        ],
      child: MyApp()
    )
);

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp,]);
    final theme = Provider.of<ThemeChanger>(context);
    return MaterialApp(
      title: 'TartanHacks Dashboard',
      debugShowCheckedModeBanner: false,
      theme: theme.getTheme,
      home: Login(),
    );
  }
}