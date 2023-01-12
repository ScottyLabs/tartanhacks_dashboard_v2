import 'package:flutter/material.dart';
import 'package:thdapp/components/ErrorDialog.dart';
import 'package:thdapp/components/background_shapes/CurvedTop.dart';
import 'package:thdapp/components/buttons/GradBox.dart';
import 'package:thdapp/components/buttons/SolidButton.dart';
import 'package:thdapp/components/topbar/TopBar.dart';
import 'package:thdapp/pages/bookmarks.dart';
import '../models/profile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thdapp/api.dart';
import 'package:flutter_smart_scan/flutter_smart_scan.dart';
import 'profile_page.dart';
import '../models/discord.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';

class Sponsors extends StatefulWidget {
  @override
  _SponsorsState createState() => _SponsorsState();
}

class _SponsorsState extends State<Sponsors> {
  String myName;
  List studentIds;
  List students; // bunch of Profiles
  List studentTeams;
  Map bookmarks; // dictionary of participant id : actual bookmark id
  DiscordInfo discordInfo;

  int searchResultCount;
  bool searchPressed;

  Widget placeholder = const Text("Search for participants by name.");

  SharedPreferences prefs;
  String token;

  final myController = TextEditingController();

  void getData() async {
    prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    bookmarks = await getBookmarkIdsList(token);
    discordInfo = await getDiscordInfo(token);
    setState(() {});
  }

  _launchDiscord() async {
    String url = discordInfo.link;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      errorDialog(context, "Error", 'Could not launch Discord Server.');
    }
  }

  void getBookmarks() async {
    bookmarks = await getBookmarkIdsList(token);
    setState(() {});
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
                      "GO TO SERVER",
                      style: Theme.of(context).textTheme.headline4,
                    ),
                    onPressed: () {
                      _launchDiscord();
                    },
                  ),
                ],
              );
            } else if (snapshot.hasError) {
              return AlertDialog(
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                title: Text("Error",
                    style: Theme.of(context).textTheme.headline1),
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

  void search() async {
    studentIds = [];
    students = [];
    studentTeams = [];
    placeholder = const CircularProgressIndicator();
    setState(() {});

    var studentData = await getStudents(token, query: myController.text);
    studentIds = studentData[0];
    students = studentData[1];
    studentTeams = studentData[2];
    placeholder = const Text("No results.");
    setState(() {});
  }

  void searchResultCounting(String keyword) {
    searchPressed = true;
    int counter = 0;
    for (var i = 0; i < students.length; i++) {
      if (students[i] != null) {
        var name = students[i].firstName + students[i].lastName;
        if (name.contains(keyword)) {
          counter++;
        }
      }
    }
    searchResultCount = counter;
    setState(() {});
  }

  void newBookmark(String bookmarkId, String participantId) async {
    prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    String newBookmarkId = await addBookmark(token, participantId);
    bookmarks[newBookmarkId] = participantId;
    setState(() {});
  }

  void removeBookmark(String bookmarkId, String participantId) async {
    prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    bookmarks.remove(bookmarkId);
    deleteBookmark(token, bookmarkId);
    setState(() {});
  }

  @override
  initState() {
    super.initState();
    getData();
  }

  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mqData = MediaQuery.of(context);
    final screenHeight = mqData.size.height;
    final screenWidth = mqData.size.width;

    return Scaffold(
      body: SingleChildScrollView(
          child: ConstrainedBox(
              constraints: BoxConstraints(maxHeight: screenHeight),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const TopBar(
                      isSponsor: true,
                    ),
                    Stack(children: [
                      Column(
                        children: [
                          CustomPaint(
                              size: Size(screenWidth, screenHeight * 0.8),
                              painter: CurvedTop(
                                  color1: Theme.of(context)
                                      .colorScheme
                                      .secondaryVariant,
                                  color2:
                                      Theme.of(context).colorScheme.primary,
                                  reverse: true)),
                        ], // children
                      ),
                      Container(
                          padding: EdgeInsets.fromLTRB(
                              screenWidth * 0.08, 0, screenWidth * 0.08, 0),
                          height: screenHeight * 0.8,
                          child: Column(children: [
                            Container(
                              alignment: Alignment.topLeft,
                              //padding: EdgeInsets.fromLTRB(35, 0, 10, 0),

                              child: Text("Welcome to TartanHacks!",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline1),
                            ),
                            const SizedBox(height: 10),
                            ButtonBar(
                                alignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  SolidButton(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .secondary,
                                    child: Text(
                                      "  Scan  ",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline2
                                          .copyWith(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onSecondary),
                                    ),
                                    onPressed: () async {
                                      String id = await FlutterBarcodeScanner.scanBarcode('#ff6666', 'Cancel', true, ScanMode.QR);
                                      Profile isValid =
                                          await getProfile(id, token);
                                      if (isValid != null) {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ProfilePage(
                                                    bookmarks: bookmarks,
                                                  ),
                                              settings: RouteSettings(
                                                arguments: id,
                                              )),
                                        ).then((value) => getBookmarks());
                                      } else {
                                        errorDialog(context, "Error",
                                            "Invalid user ID.");
                                      }
                                    },
                                  ),
                                  SolidButton(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .secondary,
                                    child: Text(
                                      " Bookmarks ",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline2
                                          .copyWith(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onSecondary),
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                Bookmarks()),
                                      );
                                    },
                                  ),
                                ]),
                            ButtonBar(
                                alignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  SolidButton(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .secondary,
                                    child: Text(
                                      "  Discord Server  ",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline2
                                          .copyWith(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onSecondary),
                                    ),
                                    onPressed: () {
                                      discordVerifyDialog(context);
                                    },
                                  ),
                                ]),
                            const SizedBox(height: 10),
                            Container(
                                alignment: Alignment.centerLeft,
                                child: Text("Search",
                                    textAlign: TextAlign.left,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline3)),
                            Row(children: [
                              Expanded(
                                child: TextField(
                                  style:
                                      Theme.of(context).textTheme.bodyText2,
                                  enableSuggestions: false,
                                  controller: myController,
                                  textInputAction: TextInputAction.send,
                                  onSubmitted: (value) {
                                    search();
                                  },
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              SolidButton(
                                  onPressed: search,
                                  child: Icon(Icons.subdirectory_arrow_left,
                                      size: 30,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimary)),
                            ]),
                            const SizedBox(height: 25),
                            if (students != null && students.isNotEmpty)
                              Expanded(
                                  child: Container(
                                      alignment: Alignment.bottomCenter,
                                      child: ListView.builder(
                                          itemCount: students.length,
                                          itemBuilder:
                                              (BuildContext context,
                                                  int index) {
                                            bool isBookmark = (bookmarks.isNotEmpty)
                                                ? bookmarks.containsValue(
                                                    studentIds[index])
                                                : false;
                                            return InfoTile(
                                                name: (students[index] != null)
                                                    ? students[index].firstName +
                                                        " " +
                                                        students[index]
                                                            .lastName
                                                    : "NULL",
                                                team: (studentTeams[index] != null)
                                                    ? studentTeams[index]
                                                    : "No team",
                                                bio: (students[index] != null)
                                                    ? students[index].college +
                                                        " c/o " +
                                                        students[index]
                                                            .graduationYear
                                                            .toString()
                                                    : "NULL",
                                                participantId:
                                                    studentIds[index],
                                                bookmarkId:
                                                    (bookmarks.isNotEmpty && bookmarks.containsValue(studentIds[index]))
                                                        ? bookmarks.keys
                                                            .firstWhere((k) =>
                                                                bookmarks[k] ==
                                                                studentIds[
                                                                    index])
                                                        : null,
                                                isBookmark: isBookmark,
                                                toggleFn: isBookmark
                                                    ? removeBookmark
                                                    : newBookmark,
                                                bmMap: bookmarks,
                                                updateBM: getBookmarks);
                                          })))
                            else
                              Center(child: placeholder)
                          ] //children
                              ))
                    ] // children
                        ),
                  ]))),
    );
  }
}

class InfoTile extends StatelessWidget {
  final String name;
  final String team;
  final String bio;
  final String participantId;
  final String bookmarkId;
  final bool isBookmark;
  final Map bmMap;

  final Function toggleFn;
  final Function updateBM;

  const InfoTile(
      {this.name,
      this.team,
      this.bio,
      this.participantId,
      this.bookmarkId,
      this.isBookmark,
      this.toggleFn,
      this.bmMap,
      this.updateBM});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
        child: GradBox(
            height: 110,
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: Row(
              children: [
                RawMaterialButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProfilePage(bookmarks: bmMap),
                          settings: RouteSettings(
                            arguments: participantId,
                          )),
                    ).then((value) => updateBM());
                  },
                  elevation: 2.0,
                  fillColor: Theme.of(context).colorScheme.primary,
                  child: Icon(
                    Icons.person,
                    size: 30.0,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                  padding: const EdgeInsets.all(12),
                  shape: const CircleBorder(),
                ),
                SizedBox(
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
                      ]),
                ),
                IconButton(
                    icon: isBookmark
                        ? const Icon(Icons.bookmark)
                        : const Icon(Icons.bookmark_outline),
                    color: Theme.of(context).colorScheme.primary,
                    iconSize: 40.0,
                    onPressed: () {
                      toggleFn(bookmarkId, participantId);
                    }),
              ],
            )));
  }
}
