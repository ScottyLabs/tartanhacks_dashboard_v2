import 'package:carousel_slider/carousel_slider.dart';
import 'package:charcode/charcode.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thdapp/api.dart';
import 'package:thdapp/components/DefaultPage.dart';
import 'package:thdapp/components/ErrorDialog.dart';
import 'package:thdapp/components/buttons/GradBox.dart';
import 'package:thdapp/components/buttons/SolidButton.dart';
import 'package:thdapp/pages/team_api.dart';
import 'package:thdapp/pages/teams_list.dart';
import 'package:thdapp/providers/user_info_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:math';

import '../models/discord.dart';
import '../models/profile.dart';
import '../models/team.dart';
import 'checkin.dart';
import 'events/index.dart';
import 'leaderboard.dart';
import 'project_submission.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  SharedPreferences prefs;
  String token;

  DiscordInfo discordInfo;

  void getData() async {
    prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    Provider.of<UserInfoModel>(context, listen: false).fetchUserInfo();

    discordInfo = await getDiscordInfo(token);

    setState(() {});
  }

  @override
  initState() {
    super.initState();
    getData();
  }

  _launchDiscord() async {
    String url = discordInfo.link;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      errorDialog(context, "Error", 'Could not launch Discord Server.');
    }
  }

  void discordVerifyDialog(BuildContext context) {
    Future discordCode = getDiscordInfo(token);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return FutureBuilder(
          future: discordCode,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return AlertDialog(
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                title: Text("Verification Code",
                    style: Theme.of(context).textTheme.headline1),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                        "When you join our Discord server, you'll be prompted to enter the following verification code by the Discord Bot running the server. This code will expire in 10 minutes.\n",
                        style: Theme.of(context).textTheme.bodyText2),
                    Text(
                      snapshot.data.code,
                      style: Theme.of(context).textTheme.headline3,
                      textAlign: TextAlign.center,
                    )
                  ],
                ),
                actions: <Widget>[
                  TextButton(
                    child: Text(
                      "COPY",
                      style: Theme.of(context).textTheme.headline4,
                    ),
                    onPressed: () {
                      Clipboard.setData(
                          ClipboardData(text: snapshot.data.code));
                    },
                  ),
                  TextButton(
                    child: Text(
                      "OK",
                      style: Theme.of(context).textTheme.headline4,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            } else if (snapshot.hasError) {
              return AlertDialog(
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                title:
                    Text("Error", style: Theme.of(context).textTheme.headline1),
                content: Text(
                    "We ran into an error while getting your Discord verification code",
                    style: Theme.of(context).textTheme.bodyText2),
                actions: <Widget>[
                  TextButton(
                    child: Text(
                      "OK",
                      style: Theme.of(context).textTheme.headline4,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            }
            return AlertDialog(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              title: Text("Verifying...",
                  style: Theme.of(context).textTheme.headline1),
              content: Container(
                  alignment: Alignment.center,
                  height: 70,
                  child: const CircularProgressIndicator()),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final mqData = MediaQuery.of(context);
    final screenHeight = mqData.size.height;
    final screenWidth = mqData.size.width;

    Profile userData = Provider.of<UserInfoModel>(context).userProfile;
    Team userTeam = Provider.of<UserInfoModel>(context).team;
    Status status = Provider.of<UserInfoModel>(context).userInfoStatus;
    bool hasTeam = Provider.of<UserInfoModel>(context).hasTeam;

    return DefaultPage(
        child: (status != Status.loaded)
            ? Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 30),
                  Center(
                      child: CircularProgressIndicator(
                          color: Theme.of(context).colorScheme.secondary))
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                      alignment: Alignment.topCenter,
                      padding: const EdgeInsets.fromLTRB(30, 0, 20, 0),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("HACKING TIME LEFT",
                                style: Theme.of(context).textTheme.headline1),
                            const SizedBox(height: 8),
                            CountdownTimer(
                              endTime: 1675549800000,
                              endWidget: Text("Time's up!",
                                  style: TextStyle(
                                      fontSize: 24.0,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).colorScheme.tertiary)
                              ),
                              textStyle: TextStyle(
                                  fontSize: 30.0,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.tertiary),
                            ),
                          ])),
                  SizedBox(height: screenHeight * 0.08),
                  Container(
                      width: screenWidth,
                      height: screenHeight * 0.10,
                      alignment: Alignment.bottomCenter,
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                      child: Text(
                        "Swipe to see all the places where\n" +
                            String.fromCharCode($larr) +
                            "the hacking is happening" +
                            String.fromCharCode(($rarr)),
                        style: Theme.of(context).textTheme.bodyText1,
                        textAlign: TextAlign.center,
                      )),
                  CarouselSlider(
                    items: [
                      GradBox(
                          width: screenWidth * 0.48,
                          height: min(screenWidth * 0.48, 200),
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
                                    textAlign: TextAlign.center,
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
                                          builder: (context) =>
                                              EventsHomeScreen()),
                                    );
                                  },
                                ),
                                SolidButton(
                                  text: "Your QR Code",
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
                          height: min(screenWidth * 0.48, 200),
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
                                          settings: const RouteSettings(
                                              name: "leaderboard"),
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
                          height: min(screenWidth * 0.48, 200),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text("Discord Server",
                                    style:
                                        Theme.of(context).textTheme.headline4),
                                Text(
                                  "Join the official TartanHacks Discord!",
                                  style: Theme.of(context).textTheme.bodyText2,
                                  textAlign: TextAlign.center,
                                ),
                                SolidButton(
                                  text: "Go to Server",
                                  onPressed: () {
                                    _launchDiscord();
                                  },
                                ),
                              ])),
                    ],
                    options: CarouselOptions(
                      height: min(screenWidth * 0.50, 200),
                      enlargeCenterPage: false,
                      autoPlayCurve: Curves.fastOutSlowIn,
                      enableInfiniteScroll: true,
                      viewportFraction: 0.5,
                    ),
                  ),
                  const SizedBox(height: 15),
                  if (hasTeam)
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
              ));
  }
}
