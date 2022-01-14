import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'custom_widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/profile.dart';

import '../models/team.dart';
import 'package:thdapp/api.dart';
import 'package:url_launcher/url_launcher.dart';
import 'team-api.dart';

class ProfilePage extends StatefulWidget {
  Map bookmarks;

  ProfilePage({this.bookmarks});

  @override
  _ProfilePageState createState() => new _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  SharedPreferences prefs;
  bool isAdmin = false;
  String id;
  String token;

  Profile userData;
  String teamName;
  bool isSelf = false;

  void getData() async{
    prefs = await SharedPreferences.getInstance();

    String email = prefs.get('email');
    String password = prefs.get('password');
    isAdmin = prefs.getBool('admin');
    token = prefs.getString('token');

    if (id == null) {
      id = prefs.getString('id');
      isSelf = true;
    }

    userData = await getProfile(id, token);

    Team userTeam = await getUserTeam(token);
    if (userTeam != null) {
      teamName = userTeam.name;
    } else {
      teamName = "No team";
    }

    setState(() {

    });
  }

  _launchResume() async {
    String url = userData.resume;
    if (await canLaunch(url)) {
      await launch(url);
    } else {

      errorDialog(context, "Error", 'Could not launch $url');
    }
  }

  _launchGithub() async {
    String url = "https://github.com/" + userData.github;
    if (await canLaunch(url)) {
      await launch(url);
    } else {

      errorDialog(context, "Error", 'Could not launch $url');
    }
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

    if (ModalRoute.of(context) != null) {
      id = ModalRoute
          .of(context)
          .settings
          .arguments as String;
    }

    return Scaffold(
        body: Container(
            child: SingleChildScrollView(
                child: ConstrainedBox(
                    constraints: BoxConstraints(
                        maxHeight: screenHeight
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TopBar(backflag: userData != null && !isSelf),
                        Stack(
                          children: [
                            Column(
                                children: [
                                  SizedBox(height: screenHeight * 0.05),
                                  CustomPaint(
                                      size: Size(
                                          screenWidth, screenHeight * 0.75),
                                      painter: CurvedTop(
                                          color1: Theme
                                              .of(context)
                                              .colorScheme
                                              .secondaryVariant,
                                          color2: Theme
                                              .of(context)
                                              .colorScheme
                                              .primary,
                                          reverse: true)
                                  ),
                                ]
                            ),
                            Container(
                                alignment: Alignment.center,
                                padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                                child: GradBox(
                                    width: screenWidth * 0.9,
                                    height: screenHeight * 0.75,
                                    padding: EdgeInsets.fromLTRB(
                                        20, 10, 20, 10),
                                    child: Container(
                                      width: screenWidth * 0.9,
                                      height: screenHeight * 0.75,
                                      child:
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment
                                            .start,
                                        crossAxisAlignment: CrossAxisAlignment
                                            .start,
                                        children: [
                                          Row(
                                            children:[
                                              Text("HACKER PROFILE", style: Theme
                                                  .of(context)
                                                  .textTheme
                                                  .headline1,),
                                              if (!isSelf && id != null)
                                                Expanded(
                                                  child: Container(
                                                    child: IconButton(
                                                        icon: widget.bookmarks.containsValue(id) ? const Icon(Icons.bookmark) : const Icon(Icons.bookmark_outline),
                                                        color: Theme.of(context).colorScheme.primary,
                                                        iconSize: 40.0,
                                                        onPressed: () async {
                                                          if (widget.bookmarks.containsValue(id)) {
                                                            String bmId = widget.bookmarks.keys.firstWhere(
                                                                    (k) => widget.bookmarks[k] == id, orElse: () => null);
                                                            deleteBookmark(token, bmId);
                                                            widget.bookmarks.remove(bmId);
                                                          } else {
                                                            String bmId = await addBookmark(token, id);
                                                            widget.bookmarks[bmId] = id;
                                                          }
                                                          setState(() {

                                                          });
                                                        }
                                                    ),
                                                  )
                                                )
                                            ]
                                          ),
                                          if (userData == null)
                                            Container(
                                              height: 100,
                                              child: Center(child: CircularProgressIndicator())
                                            )
                                          else
                                            Column(
                                                mainAxisAlignment: MainAxisAlignment
                                                    .start,
                                                crossAxisAlignment: CrossAxisAlignment
                                                    .start,
                                                children: [
                                                  Container(
                                                      height: 150,
                                                      padding: EdgeInsets.fromLTRB(
                                                          0, 10, 0, 10),
                                                      child: Row(
                                                        children: [
                                                          ClipRRect(
                                                              borderRadius: BorderRadius
                                                                  .circular(10),
                                                              child:
                                                              Image(
                                                                image: AssetImage(
                                                                    "lib/logos/defaultpfp.PNG"),
                                                              )
                                                          ),
                                                          SizedBox(width: 25),
                                                          Expanded(
                                                              child: Column(
                                                                mainAxisAlignment: MainAxisAlignment
                                                                    .end,
                                                                crossAxisAlignment: CrossAxisAlignment
                                                                    .start,
                                                                children: [
                                                                  Text(userData.firstName,
                                                                      style: Theme
                                                                          .of(context)
                                                                          .textTheme
                                                                          .headline3
                                                                  ),
                                                                  Text(userData.lastName,
                                                                      style: Theme
                                                                          .of(context)
                                                                          .textTheme
                                                                          .headline3
                                                                  ),
                                                                  Text('"' + userData.displayName + '"',
                                                                      style: Theme
                                                                          .of(context)
                                                                          .textTheme
                                                                          .bodyText2
                                                                  ),

                                                                  Text(teamName,
                                                                      style: Theme
                                                                          .of(context)
                                                                          .textTheme
                                                                          .bodyText2
                                                                  ),
                                                                ],
                                                              )
                                                          )
                                                        ],
                                                      )
                                                  ),
                                                  if (isSelf)
                                                  SolidButton(
                                                    text: "Edit Nickname",
                                                  ),
                                                  SizedBox(height: 10),
                                                  Text(userData.school,
                                                      style: Theme
                                                          .of(context)
                                                          .textTheme
                                                          .headline3
                                                  ),
                                                  Text(userData.major,
                                                      style: Theme
                                                          .of(context)
                                                          .textTheme
                                                          .bodyText2
                                                  ),
                                                  Text("Expected graduation "+ userData.graduationYear.toString(),
                                                      style: Theme
                                                          .of(context)
                                                          .textTheme
                                                          .bodyText2
                                                  ),
                                                  Row(
                                                    children: [
                                                      ButtonBar(
                                                        children: [
                                                          SolidButton(
                                                            text: " Link to GitHub ",
                                                            onPressed: () => _launchGithub(),
                                                          ),
                                                          SolidButton(
                                                            text: " View Resume ",
                                                            onPressed: () => _launchResume(),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  )
                                                  /*SizedBox(height: 8),
                                          Text("Bio:",
                                              style: Theme
                                                  .of(context)
                                                  .textTheme
                                                  .bodyText2
                                          ),
                                          Container(
                                              height: 100,
                                              padding: EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                color: darken(Theme
                                                    .of(context)
                                                    .colorScheme
                                                    .surface, 0.04),
                                                borderRadius: BorderRadius
                                                    .circular(15),
                                              ),
                                              child: SingleChildScrollView(
                                                child: Text(
                                                  "Lorem ipsum dolor sit amet, consectetur adipiscing elit, "
                                                      "sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. "
                                                      "Ut enim ad minim veniam, quis nostrud exercitation ullamco "
                                                      "laboris nisi ut aliquip ex ea commodo consequat.",
                                                  style: Theme
                                                      .of(context)
                                                      .textTheme
                                                      .bodyText2,
                                                ),
                                              )
                                          ),
                                          SizedBox(height: 8),*/
                                                ]
                                            )
                                        ],
                                      ),
                                    )
                                )
                            )
                          ],
                        )
                      ],
                    )
                )
            )
        )
    );
  }
}