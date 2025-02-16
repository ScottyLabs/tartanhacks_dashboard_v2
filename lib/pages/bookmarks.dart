import 'package:flutter/material.dart';
import 'package:thdapp/components/DefaultPage.dart';
import 'package:thdapp/components/buttons/GradBox.dart';
import 'package:thdapp/components/buttons/SolidButton.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thdapp/api.dart';
import 'profile_page.dart';
import '../models/participant_bookmark.dart';

class Bookmarks extends StatefulWidget {
  @override
  _Bookmarks createState() => _Bookmarks();
}

class _Bookmarks extends State<Bookmarks> {
  late List participantBookmarks;
  late List projectBookmarks;
  late Map bookmarksMap;
  late SharedPreferences prefs;
  late String token;

  void getData() async {
    prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token')!;
    participantBookmarks = await getParticipantBookmarks(token);
    projectBookmarks = await getProjectBookmarks(token);
    bookmarksMap = await getBookmarkIdsList(token);
    setState(() {});
  }

  void removeBookmark(String id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          title: Text("Confirm", style: Theme.of(context).textTheme.displayLarge),
          content: Text("Are you sure you want to delete this bookmark?",
              style: Theme.of(context).textTheme.bodyMedium),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            TextButton(
              child: Text(
                "Cancel",
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                "Yes",
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              onPressed: () {
                deleteBookmark(token, id);
                for (var bm in participantBookmarks) {
                  if (bm.bookmarkId == id) {
                    participantBookmarks.remove(bm);
                    break;
                  }
                }
                setState(() {});
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
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

    return DefaultPage(
        isSponsor: true,
        reverse: true,
        child: Column(
          children: [
            SizedBox(
                height: screenHeight * 0.80,
                child: Column(children: [
                  Container(
                    alignment: Alignment.topLeft,
                    padding: EdgeInsets.fromLTRB(
                        screenWidth * 0.08, 0, screenWidth * 0.08, 0),
                    child: Text("BOOKMARKS",
                        style: Theme.of(context).textTheme.displayMedium),
                  ),
                  Container(
                    alignment: Alignment.topLeft,
                    padding: EdgeInsets.fromLTRB(
                        screenWidth * 0.08, 0, screenWidth * 0.08, 0),
                    child: Text("Scroll to see the full list.",
                        style: TextStyle(fontSize: screenHeight * 0.02)),
                  ),
                  const SizedBox(height: 5),
                  Expanded(
                      child: (participantBookmarks.isNotEmpty)
                          ? Container(
                              padding: EdgeInsets.fromLTRB(screenWidth * 0.05,
                                  0, screenWidth * 0.05, 0),
                              alignment: Alignment.topCenter,
                              child: ListView.builder(
                                itemCount: participantBookmarks.length,
                                itemBuilder:
                                    (BuildContext context, int index) {
                                  return BookmarkInfo(
                                    bmID: participantBookmarks[index]
                                        .bookmarkId,
                                    data: participantBookmarks[index]
                                        .participantData,
                                    team: "ScottyLabs",
                                    bio: "[Bio]",
                                    remove: removeBookmark,
                                    bmMap: bookmarksMap,
                                    refresh: getData,
                                  );
                                },
                              ))
                          : Container(
                              padding: EdgeInsets.fromLTRB(screenWidth * 0.05,
                                  0, screenWidth * 0.05, 0),
                              alignment: Alignment.center,
                              child: Text("No bookmarks.",
                                  style: Theme.of(context)
                                      .textTheme
                                      .displaySmall
                                      ?.copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onPrimary))))
                ]))
          ], // children
        ));
  }
}

class BookmarkInfo extends StatelessWidget {
  final ParticipantInfo data;
  final String bmID;
  final String team;
  final String bio;
  final Function remove;
  final Map bmMap;
  final Function refresh;

  const BookmarkInfo(
      {required this.bmID,
      required this.data,
      required this.team,
      required this.bio,
      required this.remove,
      required this.bmMap,
      required this.refresh});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
      child: GradBox(
          alignment: Alignment.topLeft,
          width: 200,
          height: 180,
          child: Row(children: [
            Container(
              width: 230,
              padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("${data.firstName} ${data.lastName}",
                        style: Theme.of(context).textTheme.headlineMedium),
                    Text(team, style: Theme.of(context).textTheme.bodyMedium),
                    /*Text(
                            bio,
                            style: Theme.of(context).textTheme.bodyMedium
                        ),*/
                    const SizedBox(height: 18),
                    SolidButton(
                      text: "View More",
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProfilePage(
                                    bookmarks: bmMap,
                                  ),
                              settings: RouteSettings(
                                arguments: data.id,
                              )),
                        ).then((value) => refresh());
                      },
                    )
                  ]),
            ),
            RawMaterialButton(
              onPressed: () {
                remove(bmID);
              },
              elevation: 2.0,
              fillColor: Theme.of(context).colorScheme.primary,
              padding: const EdgeInsets.all(12),
              shape: const CircleBorder(),
              child: Icon(
                Icons.bookmark,
                size: 50.0,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          ])),
    );
  }
}
