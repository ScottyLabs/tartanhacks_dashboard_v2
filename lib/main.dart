import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

import 'package:thdapp/providers/check_in_items_provider.dart';
import 'package:thdapp/providers/user_info_provider.dart';
import 'pages/login.dart';
import 'theme_changer.dart';
import 'package:thdapp/providers/expo_config_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    await dotenv.load( fileName: ".env");
  } catch (e) {
    print(e);
  }
  
  runApp(
    MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => CheckInItemsModel()),
          ChangeNotifierProvider(create: (_) => ThemeChanger(lightTheme)),
          ChangeNotifierProvider(create: (context) => UserInfoModel()),
          ChangeNotifierProvider(create: (_) => ExpoConfigProvider()),
        ],
      child: MyApp()
    )
);}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [SystemUiOverlay.bottom]);
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