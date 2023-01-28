import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thdapp/components/menu/MenuChoice.dart';
import 'package:thdapp/components/menu/MenuFunctions.dart';
import 'package:thdapp/components/menu/WhiteOverlay.dart';
import 'package:thdapp/pages/checkin.dart';
import 'package:thdapp/pages/events/index.dart';
import 'package:thdapp/pages/home.dart';
import 'package:thdapp/pages/profile_page.dart';
import 'package:thdapp/pages/project_submission.dart';
import 'package:thdapp/pages/teams_list.dart';
import 'package:thdapp/pages/view_team.dart';
import 'package:thdapp/providers/user_info_provider.dart';
import '../../../theme_changer.dart';
import './MenuButton.dart';

OverlayEntry menuOverlay(BuildContext context) {
  final mqData = MediaQuery.of(context);
  final screenWidth = mqData.size.width;
  var _themeProvider = Provider.of<ThemeChanger>(context, listen: false);
  bool hasTeam = Provider.of<UserInfoModel>(context, listen: false).hasTeam;
  OverlayEntry entry;

  entry = OverlayEntry(
      builder: (context) => GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              entry.remove();
            },
            child: Stack(alignment: Alignment.topRight, children: [
              CustomPaint(size: mqData.size, painter: WhiteOverlay()),
              SafeArea(
                  child: Column(children: [
                Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                  Container(
                      width: screenWidth / 4,
                      alignment: Alignment.topRight,
                      padding: const EdgeInsets.fromLTRB(0, 25, 17, 0),
                      child: MenuButton(
                          onTap: () {
                            entry.remove();
                          },
                          icon: Icons.close)),
                ]),
                const SizedBox(height: 10),
                Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(children: [
                        MenuChoice(
                          icon: Icons.schedule,
                          text: "Schedule",
                          onTap: () {
                            entry.remove();
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EventsHomeScreen(),
                                ),
                                (route) => route.isFirst);
                          },
                        ),
                        MenuChoice(
                          icon: Icons.pages,
                          text: "Project",
                          onTap: () {
                            entry.remove();
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProjSubmit(),
                                ),
                                (route) => route.isFirst);
                          },
                        ),
                        MenuChoice(
                          icon: Icons.home,
                          text: "Home",
                          onTap: () {
                            entry.remove();
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(builder: (context) => Home()),
                                (route) => false);
                          },
                        ),
                        _themeProvider.getTheme == lightTheme
                            ? MenuChoice(
                                icon: Icons.mode_night,
                                text: "Dark",
                                onTap: () {
                                  _themeProvider.setTheme(darkTheme);
                                  setThemePref("dark", entry, context);
                                },
                              )
                            : MenuChoice(
                                icon: Icons.wb_sunny,
                                text: "Light",
                                onTap: () {
                                  _themeProvider.setTheme(lightTheme);
                                  setThemePref("light", entry, context);
                                },
                              ),
                      ]),
                      Column(
                        children: [
                          MenuChoice(
                            icon: Icons.people_alt,
                            text: "Team",
                            onTap: () {
                              entry.remove();
                              Provider.of<UserInfoModel>(context, listen: false)
                                  .fetchUserInfo();
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  hasTeam
                                      ? MaterialPageRoute(
                                          builder: (context) => ViewTeam(),
                                          settings: const RouteSettings(
                                            arguments: "",
                                          ))
                                      : MaterialPageRoute(
                                          builder: (context) => TeamsList()),
                                  (route) => route.isFirst);
                            },
                          ),
                          MenuChoice(
                            icon: Icons.qr_code_scanner,
                            text: "Scan",
                            onTap: () {
                              entry.remove();
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CheckIn(),
                                  ),
                                  (route) => route.isFirst);
                            },
                          ),
                          MenuChoice(
                            icon: Icons.person,
                            text: "Profile",
                            onTap: () {
                              entry.remove();
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      settings:
                                          const RouteSettings(name: "profpage"),
                                      builder: (context) =>
                                          const ProfilePage()),
                                  (route) => route.isFirst);
                            },
                          ),
                          MenuChoice(
                              icon: Icons.logout,
                              text: "Logout",
                              onTap: () {
                                logOut(entry, context);
                              }),
                        ],
                      )
                    ])
              ])),
            ]),
          ));
  return entry;
}
