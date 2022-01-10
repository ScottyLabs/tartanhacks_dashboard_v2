import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'custom_widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thdapp/api.dart';

import '../models/participant_bookmark.dart';


class Bookmarks extends StatefulWidget {
  @override
  _Bookmarks createState() => new _Bookmarks();
}

class _Bookmarks extends State<Bookmarks> {
  List participantBookmarks;
  List projectBookmarks;
  SharedPreferences prefs;
  String token;


  void getData() async {
    prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    participantBookmarks = await getParticipantBookmarks(token);
    print('Participant Bookmarks:');
    print(participantBookmarks);
    projectBookmarks = await getProjectBookmarks(token);
    print('Project Bookmarks:');
    print(projectBookmarks);
    setState(() {

    });
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

    if (participantBookmarks == null || projectBookmarks == null) {
      return LoadingScreen();
    }
    else {
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
                          TopBar(isSponsor: true),
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
                                    ] // children
                                ),
                                Container(
                                  child: Column(
                                    children: [
                                      Container(
                                          height: screenHeight * 0.80,
                                          child: Column(
                                              children: [
                                                Container(
                                                  alignment: Alignment.topLeft,
                                                  padding: EdgeInsets.fromLTRB(
                                                      screenWidth * 0.08, 0,
                                                      screenWidth * 0.08, 0),
                                                  child: Text(
                                                      "BOOKMARKS", style: Theme
                                                      .of(context)
                                                      .textTheme
                                                      .headline2),
                                                ),
                                                Container(
                                                  alignment: Alignment.topLeft,
                                                  padding: EdgeInsets.fromLTRB(
                                                      screenWidth * 0.08, 0,
                                                      screenWidth * 0.08, 0),
                                                  child: Text(
                                                      "Scroll to see the full list.",
                                                      style: TextStyle(
                                                          fontSize: screenHeight *
                                                              0.02)),
                                                ),
                                                Expanded(
                                                    child: (participantBookmarks.length != 0) ?
                                                    Container(
                                                        padding: EdgeInsets
                                                            .fromLTRB(
                                                            screenWidth * 0.05,
                                                            0,
                                                            screenWidth * 0.05,
                                                            0),
                                                        alignment: Alignment
                                                            .topCenter,
                                                        child: ListView.builder(
                                                          itemCount: participantBookmarks
                                                              .length,
                                                          itemBuilder: (
                                                              BuildContext context,
                                                              int index) {
                                                            return BookmarkInfo(
                                                                data: participantBookmarks[index].participantData,
                                                                team: "ScottyLabs",
                                                                bio: "[Bio]"
                                                            );
                                                          },
                                                        )
                                                    ) :
                                                    Container(
                                                        padding: EdgeInsets
                                                            .fromLTRB(
                                                            screenWidth * 0.05,
                                                            0,
                                                            screenWidth * 0.05,
                                                            0),
                                                        alignment: Alignment
                                                            .center,
                                                        child: Text(
                                                            "No bookmarks.",
                                                            style: Theme
                                                                .of(context)
                                                                .textTheme
                                                                .headline3)
                                                    )
                                                )
                                              ]
                                          )
                                      )
                                    ], // children
                                  ),
                                )
                              ]
                          ),
                        ]
                    ),
                  )
              )
          )
      );
    }
  }
}

class BookmarkInfo extends StatelessWidget {

  ParticipantInfo data;
  String team;
  String bio;

  BookmarkInfo({this.data, this.team, this.bio});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
      child: GradBox(
          alignment: Alignment.topLeft,
          width: 200,
          height: 180,
          child: Row(
              children: [
                Container(
                  width: 230,
                  padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(

                            data.firstName + " " + data.lastName,
                            style: Theme.of(context).textTheme.headline4
                        ),
                        Text(
                            team,
                            style: Theme.of(context).textTheme.bodyText2
                        ),
                        Text(
                            bio,
                            style: Theme.of(context).textTheme.bodyText2
                        ),
                        SizedBox(height: 18),
                        SolidButton(
                          text: "View More",
                        )
                      ]
                  ),
                ),
                RawMaterialButton(
                  onPressed: null,
                  elevation: 2.0,
                  fillColor: Theme.of(context).colorScheme.primary,
                  child: Icon(
                    Icons.bookmark,
                    size: 50.0,
                    color: Theme.of(context).colorScheme.background,
                  ),
                  padding: EdgeInsets.all(12),
                  shape: CircleBorder(),
                ),
              ]
          )
      ),
    );
  }
}