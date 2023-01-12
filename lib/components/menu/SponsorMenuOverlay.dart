import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thdapp/pages/bookmarks.dart';
import 'package:thdapp/pages/events/index.dart';
import 'package:thdapp/pages/sponsors.dart';
import 'package:thdapp/theme_changer.dart';
import './MenuButton.dart';
import 'MenuChoice.dart';
import 'WhiteOverlay.dart';
import 'package:thdapp/components/menu/MenuFunctions.dart';

OverlayEntry sponsorMenuOverlay(BuildContext context) {
  final mqData = MediaQuery.of(context);
  final screenWidth = mqData.size.width;

  var _themeProvider = Provider.of<ThemeChanger>(context, listen: false);
  OverlayEntry entry;

  entry = OverlayEntry(
      builder: (context) => GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            entry.remove();
          },
          child: Stack(
              alignment: Alignment.topRight,
              children:[
                CustomPaint(
                    size: mqData.size,
                    painter: WhiteOverlay()
                ),
                Column(
                    children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children:[
                            Container(
                                width: screenWidth/4,
                                alignment: Alignment.topRight,
                                padding: const EdgeInsets.fromLTRB(0, 25, 17, 0),
                                child: MenuButton(
                                  onTap: () {
                                    entry.remove();
                                  },
                                  icon: Icons.close,
                                )
                            ),
                          ]
                      ),
                      const SizedBox(height: 10),
                      Container(
                          alignment: Alignment.topRight,
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children:[
                                MenuChoice(
                                  icon: Icons.person,
                                  text: "Home",
                                  onTap: () {
                                    entry.remove();
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) =>
                                            Sponsors(),
                                        )
                                    );
                                  },
                                ),
                                MenuChoice(
                                  icon: Icons.schedule,
                                  text: "Schedule",
                                  onTap: () {
                                    entry.remove();
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) =>
                                            EventsHomeScreen(),
                                        )
                                    );
                                  },
                                ),
                                MenuChoice(
                                  icon: Icons.bookmark_outline,
                                  text: "Bookmarks",
                                  onTap: () {
                                    entry.remove();
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) =>
                                            Bookmarks(),
                                        )
                                    );
                                  },
                                ),

                                _themeProvider.getTheme==lightTheme ?
                                MenuChoice(
                                  icon: Icons.mode_night,
                                  text: "Dark",
                                  onTap: () {
                                    _themeProvider.setTheme(darkTheme);
                                    setThemePref("dark", entry, context);
                                  },
                                ) :
                                MenuChoice(
                                  icon: Icons.wb_sunny,
                                  text: "Light",
                                  onTap: () {
                                    _themeProvider.setTheme(lightTheme);
                                    setThemePref("light", entry, context);
                                  },
                                ),
                                MenuChoice(
                                  icon: Icons.logout,
                                  text: "Logout",
                                  onTap: () {logOut(entry, context);},
                                ),
                              ]
                          )
                      )
                    ]
                )
              ]
          )
      )
  );
  return entry;
}