import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thdapp/api.dart';
import 'package:thdapp/pages/team-api.dart';
import 'package:thdapp/pages/teams_list.dart';
import 'custom_widgets.dart';
import 'package:charcode/charcode.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'project_submission.dart';
import 'profile_page.dart';
import 'leaderboard.dart';
import '../models/profile.dart';
import '../models/team.dart';
import 'checkin.dart';
import 'events/index.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => new _HomeState();
}

class _HomeState extends State<Home> {
  SharedPreferences prefs;
  bool isAdmin = false;
  String id;
  String token;

  Profile userData;
  Team userTeam;

  void getData() async {
    prefs = await SharedPreferences.getInstance();

    isAdmin = prefs.getBool('admin');
    id = prefs.getString('id');
    token = prefs.getString('token');

    userData = await getProfile(id, token);
    userTeam = await getUserTeam(token);

    setState(() {});
  }

  @override
  initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    final mqData = MediaQuery.of(context);
    final screenHeight = mqData.size.height;
    final screenWidth = mqData.size.width;
    return Scaffold(
      body: Container(
          child: Column(mainAxisAlignment: MainAxisAlignment.end, children: <
              Widget>[
        TopBar(),
        Stack(
          children: [
            Column(children: [
              SizedBox(height: screenHeight * 0.05),
              CustomPaint(
                  size: Size(screenWidth, screenHeight * 0.75),
                  painter: CurvedTop(
                      color1: Theme.of(context).colorScheme.primary,
                      color2: Theme.of(context).colorScheme.secondaryVariant)),
            ]),
            if (userData == null)
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 30),
                  Center(
                      child: CircularProgressIndicator(
                          color: Theme.of(context).colorScheme.secondary))
                ],
              )
            else
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                      alignment: Alignment.topLeft,
                      padding: EdgeInsets.fromLTRB(30, 0, 20, 0),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("HACKING TIME LEFT",
                                style: Theme.of(context).textTheme.headline1),
                            SizedBox(height: 8),
                            CountdownTimer(
                              endTime: 1644954396000,
                              textStyle: TextStyle(
                                  fontSize: 30.0,
                                  fontWeight: FontWeight.bold,
                                  color:
                                      Theme.of(context).colorScheme.secondary),
                            ),
                          ])),
                  SizedBox(height: screenHeight * 0.08),
                  Container(
                      width: screenWidth,
                      height: screenHeight * 0.10,
                      alignment: Alignment.bottomCenter,
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
                      child: Text(
                        "Swipe to see all the places where the\n" +
                            String.fromCharCode($larr) +
                            "hacking is happening" +
                            String.fromCharCode(($rarr)),
                        style: Theme.of(context).textTheme.bodyText1,
                        textAlign: TextAlign.center,
                      )),
                  CarouselSlider(
                    items: [
                      GradBox(
                          width: screenWidth * 0.48,
                          height: screenWidth * 0.48,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                    "Hi " +
                                        userData.firstName +
                                        " " +
                                        userData.lastName +
                                        "!",
                                    style:
                                        Theme.of(context).textTheme.headline4),
                                Text(
                                  "Welcome to TartanHacks!",
                                  style: Theme.of(context).textTheme.bodyText2,
                                  textAlign: TextAlign.center,
                                ),
                                
                                SolidButton(
                                  text: "View Schedule",
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => EventsHomeScreen()),
                                    );
                                  },
                                )
                              ])),
                      GradBox(
                          width: screenWidth * 0.48,
                          height: screenWidth * 0.48,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text("Swag Points",
                                    style:
                                        Theme.of(context).textTheme.headline4),
                                Text(
                                    "Points Earned: " +
                                        userData.totalPoints.toString(),
                                    style:
                                        Theme.of(context).textTheme.bodyText2),
                                SolidButton(
                                  text: "Leaderboard",
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Leaderboard()),
                                    );
                                  },
                                ),
                                SolidButton(
                                  text: "Check In",
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => CheckIn()),
                                    );
                                  },
                                )
                              ])),
                      GradBox(
                          width: screenWidth * 0.48,
                          height: screenWidth * 0.48,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                SolidButton(
                                  text: "Discord",
                                  onPressed: null,
                                ),
                                SolidButton(
                                  text: "Hopin",
                                  onPressed: null,
                                ),
                                SolidButton(
                                  text: "TH Website",
                                  onPressed: null,
                                )
                              ])),
                    ],
                    options: CarouselOptions(
                      height: screenWidth * 0.50,
                      enlargeCenterPage: false,
                      autoPlayCurve: Curves.fastOutSlowIn,
                      enableInfiniteScroll: true,
                      viewportFraction: 0.5,
                    ),
                  ),
                  SizedBox(height: 15),
                  if (userTeam != null)
                    GradBox(
                      width: screenWidth * 0.9,
                      height: 60,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ProjSubmit()),
                        );
                      },
                      child: Text(
                        "VIEW YOUR PROJECT",
                        style: Theme.of(context).textTheme.headline2,
                      ),
                    )
                  else
                    GradBox(
                      width: screenWidth * 0.9,
                      height: 60,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => TeamsList()),
                        );
                      },
                      child: Text(
                        "JOIN A TEAM",
                        style: Theme.of(context).textTheme.headline2,
                      ),
                    )
                ],
              )
          ],
        ),
      ])),
    );
  }
}
