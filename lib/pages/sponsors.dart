import 'package:charcode/html_entity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'custom_widgets.dart';
import '../models/profile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thdapp/api.dart';

class Sponsors extends StatefulWidget {
  @override
  _SponsorsState createState() => new _SponsorsState();
}

class _SponsorsState extends State<Sponsors> {
  List studentIds;
  List students;
  Map bookmarks; // dictionary of participant id : actual bookmark id

  SharedPreferences prefs;
  String token;

  void getData() async{
    prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    List studentData = await getStudents(token);
    studentIds = studentData[0];
    students = studentData[1];
    print('students: ' + students.toString());
    bookmarks = await getBookmarkIdsList(token);
    print('bookmarks: ' + bookmarks.toString());
    setState(() {

    });
  }

  void toggleBookmark(String bookmarkId, String participantId) async {
    prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    print('toggling now!');
    if (bookmarks.containsKey(bookmarkId)) {
      print('gonna delete');
      bookmarks.remove(bookmarkId);
      print(bookmarks);
      deleteBookmark(token, bookmarkId);
    }
    else {
      print('gonna add');
      var newBookmarkId = addBookmark(token, bookmarkId);
      bookmarks[newBookmarkId] = participantId;
      print(bookmarks);
    }
  }

  // separate functions for adding and deleting bookmarks

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

    if (students == null) {
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
                          TopBar(isSponsor: true,),
                          Stack(
                              children: [
                                Column(
                                  children:[
                                    CustomPaint(
                                        size: Size(screenWidth, screenHeight * 0.8),
                                        painter: CurvedTop(
                                            color1: Theme.of(context).colorScheme.secondaryVariant,
                                            color2: Theme.of(context).colorScheme.primary,
                                            reverse: true)
                                    ),
                                  ], // children
                                ),
                                Container(
                                    padding: EdgeInsets.fromLTRB(screenWidth * 0.08, 0, screenWidth * 0.08, 0),
                                    height: screenHeight *0.8,
                                    child: Column(
                                        children: [
                                          Container(
                                            alignment: Alignment.topLeft,
                                            //padding: EdgeInsets.fromLTRB(35, 0, 10, 0),
                                            child: Text("HI [SPONSOR NAME], WELCOME BACK", style: Theme.of(context).textTheme.headline1),
                                          ),
                                          SizedBox(height: 10),
                                          Container(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                  "Search",
                                                  textAlign: TextAlign.left,
                                                  style: Theme.of(context).textTheme.headline3
                                              )
                                          ),
                                          Container(
                                            child: TextField(
                                              decoration: InputDecoration(fillColor: Colors.white, filled: true, border: InputBorder.none),
                                              style: Theme.of(context).textTheme.bodyText2,
                                              enableSuggestions: false,
                                            ),
                                          ),
                                          Container(
                                            height: 60,
                                            alignment: Alignment.centerRight,
                                            child: GradBox(
                                                alignment: Alignment.center,
                                                width: 80,
                                                height: 40,
                                                child: Icon(
                                                    Icons.subdirectory_arrow_left,
                                                    size: 30,
                                                    color: Theme.of(context).colorScheme.onSurface
                                                )
                                            ),
                                          ),
                                          Expanded(
                                              child: Container(
                                                  alignment: Alignment.bottomCenter,
                                                  child: ListView.builder(
                                                      itemCount: 4,
                                                      itemBuilder: (BuildContext context, int index){
                                                        return InfoTile(
                                                            name: (students[index] != null) ? students[index].firstName + " " + students[index].lastName : "NULL",
                                                            team: "Cool Team",
                                                            bio: (students[index] != null) ? students[index].college + " c/o " + students[index].graduationYear.toString() : "NULL",
                                                            participantId: studentIds[index],
                                                            bookmarkId: (bookmarks.length != 0 && bookmarks.containsValue(studentIds[index])) ? bookmarks.keys.firstWhere((k) => bookmarks[k] == studentIds[index]) : null,
                                                            isBookmark: (bookmarks.length != 0) ? bookmarks.containsValue(studentIds[index]) : false,
                                                            toggle: toggleBookmark,
                                                        );
                                                      }
                                                  )

                                              )
                                          )
                                        ] //children
                                    )
                                )
                              ] // children
                          ),
                        ]
                    )
                )
            )
        ),
      );
    }
  }
}


class InfoTile extends StatelessWidget {
  String name;
  String team;
  String bio;
  String participantId;
  String bookmarkId;
  bool isBookmark;
  Function toggle;

  InfoTile({this.name, this.team, this.bio, this.participantId, this.bookmarkId, this.isBookmark, this.toggle});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
        child: GradBox(
            height: 110,
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: Row(
              children: [
                RawMaterialButton(
                  onPressed: null,
                  elevation: 2.0,
                  fillColor: Theme.of(context).colorScheme.primary,
                  child: Icon(
                    Icons.person,
                    size: 30.0,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                  padding: EdgeInsets.all(12),
                  shape: CircleBorder(),
                ),
                Container(
                  width: 180,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          textAlign: TextAlign.left,
                          style: Theme.of(context).textTheme.headline4,
                        ),
                        Text(
                          team,
                          textAlign: TextAlign.left,
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                        Text(
                          bio,
                          textAlign: TextAlign.left,
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                      ]
                  ),
                ),
                IconButton(
                  icon: isBookmark ? const Icon(Icons.bookmark) : const Icon(Icons.bookmark_outline),
                  color: Theme.of(context).colorScheme.primary,
                  iconSize: 40.0,
                  onPressed: () {
                    toggle(bookmarkId, participantId);
                  }
                ),
              ],
            )
        )
    );
  }
}
