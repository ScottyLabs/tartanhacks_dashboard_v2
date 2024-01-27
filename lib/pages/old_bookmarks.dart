import 'package:flutter/material.dart';
import 'package:thdapp/components/background_shapes/CurvedTop.dart';
import 'package:thdapp/components/buttons/GradBox.dart';
import 'package:thdapp/components/buttons/SolidButton.dart';
import 'package:thdapp/components/topbar/TopBar.dart';

class OldBookmarks extends StatelessWidget {
  final List bookmarks = [
    "[Student A]",
    "[Student B]",
    "[Student C]",
    "[Student D]",
    "[Student E]",
    "[Student F]",
    "[Student G]",
    "[Student F]"
  ];
  final bool isProjects = true;

  @override
  Widget build(BuildContext context) {
    final mqData = MediaQuery.of(context);
    final screenHeight = mqData.size.height;
    final screenWidth = mqData.size.width;

    return Scaffold(
        body: SingleChildScrollView(
            child: ConstrainedBox(
      constraints: BoxConstraints(maxHeight: screenHeight),
      child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
        const TopBar(),
        Stack(children: [
          Column(children: [
            SizedBox(height: screenHeight * 0.05),
            CustomPaint(
                size: Size(screenWidth, screenHeight * 0.75),
                painter: CurvedTop(
                    color1: Theme.of(context).colorScheme.secondaryContainer,
                    color2: Theme.of(context).colorScheme.primary,
                    reverse: true)),
          ] // children
              ),
          Column(
            children: [
              SizedBox(
                  height: screenHeight * 0.80,
                  child: Column(children: [
                    Row(children: [
                      Container(
                        alignment: Alignment.topLeft,
                        padding: EdgeInsets.fromLTRB(
                            screenWidth * 0.08, 0, screenWidth * 0.08, 0),
                        child: Text("BOOKMARKS",
                            style: Theme.of(context).textTheme.displayMedium),
                      ),
                      Switch(
                        value: isProjects,
                        // onChanged: (value) {
                        //   setState(() {
                        //     isProjects = value;
                        //   });
                        // },
                        activeTrackColor: const Color(0xFFF6C744),
                        activeColor: const Color(0xFFF68F44),
                      ),
                    ]),
                    Container(
                      alignment: Alignment.topLeft,
                      padding: EdgeInsets.fromLTRB(
                          screenWidth * 0.08, 0, screenWidth * 0.08, 0),
                      child: Text(
                          "Scroll for the full list. Toggle for projects.",
                          style: TextStyle(fontSize: screenHeight * 0.02)),
                    ),
                    Expanded(
                        child: Container(
                      padding: EdgeInsets.fromLTRB(
                          screenWidth * 0.05, 0, screenWidth * 0.05, 0),
                      alignment: Alignment.topCenter,
                      child: ListView.builder(
                        itemCount: bookmarks.length,
                        itemBuilder: (BuildContext context, int index) {
                          return BookmarkInfo(
                              name: bookmarks[index],
                              team: "ScottyLabs",
                              bio: "[Bio]");
                        },
                      ),
                    ))
                  ]))
            ], // children
          )
        ]),
      ]),
    )));
  }
}

class BookmarkInfo extends StatelessWidget {
  final String name;
  final String team;
  final String bio;

  const BookmarkInfo(
      {required this.name, required this.team, required this.bio});

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
                    Text(name,
                        style: Theme.of(context).textTheme.headlineMedium),
                    Text(team, style: Theme.of(context).textTheme.bodyMedium),
                    Text(bio, style: Theme.of(context).textTheme.bodyMedium),
                    const SizedBox(height: 18),
                    SolidButton(
                      text: "View More",
                      onPressed: () {
                        viewMorePopup(context, 'View More', 'hello');
                      },
                    )
                  ]),
            ),
            RawMaterialButton(
              onPressed: null,
              elevation: 2.0,
              fillColor: Theme.of(context).colorScheme.primary,
              padding: const EdgeInsets.all(12),
              shape: const CircleBorder(),
              child: Icon(
                Icons.bookmark,
                size: 50.0,
                color: Theme.of(context).colorScheme.background,
              ),
            ),
          ])),
    );
  }
}

void viewMorePopup(context, String title, String response) {
  // flutter defined function
  showDialog(
    context: context,
    builder: (BuildContext context) {
      // return object of type Dialog
      return AlertDialog(
        title: Text(title, style: Theme.of(context).textTheme.displayLarge),
        content: Text(response, style: Theme.of(context).textTheme.bodyMedium),
        actions: <Widget>[
          // usually buttons at the bottom of the dialog
          TextButton(
            child: Text(
              "Close",
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
