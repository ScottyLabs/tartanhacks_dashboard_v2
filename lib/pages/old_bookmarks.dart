import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'custom_widgets.dart';

class OldBookmarks extends StatelessWidget {
  List bookmarks = ["[Student A]", "[Student B]", "[Student C]", "[Student D]",
                    "[Student E]", "[Student F]", "[Student G]", "[Student F]"];
  bool isProjects = true;

  @override
  Widget build(BuildContext context) {
    final mqData = MediaQuery.of(context);
    final screenHeight = mqData.size.height;
    final screenWidth = mqData.size.width;

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
                        TopBar(),
                        Stack(
                            children: [
                              Column(
                                children:[
                                  SizedBox(height:screenHeight * 0.05),
                                  CustomPaint(
                                      size: Size(screenWidth, screenHeight * 0.75),
                                      painter: CurvedTop(
                                          color1: Theme.of(context).colorScheme.secondaryVariant,
                                          color2: Theme.of(context).colorScheme.primary,
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
                                              Row(
                                                children: [
                                                  Container(
                                                    alignment: Alignment.topLeft,
                                                    padding: EdgeInsets.fromLTRB(screenWidth * 0.08, 0, screenWidth * 0.08, 0),
                                                    child: Text("BOOKMARKS", style: Theme.of(context).textTheme.headline2),
                                                  ),
                                                  Container(
                                                    child: Switch(
                                                      value: isProjects,
                                                      // onChanged: (value) {
                                                      //   setState(() {
                                                      //     isProjects = value;
                                                      //   });
                                                      // },
                                                      activeTrackColor: Color(0xFFF6C744),
                                                      activeColor: Color(0xFFF68F44),
                                                    ),
                                                  ),
                                                ]
                                              ),
                                              Container(
                                                alignment: Alignment.topLeft,
                                                padding: EdgeInsets.fromLTRB(screenWidth * 0.08, 0, screenWidth * 0.08, 0),
                                                child: Text("Scroll for the full list. Toggle for projects.", style: TextStyle(fontSize: screenHeight * 0.02)),
                                              ),
                                              Expanded(
                                                  child: Container(
                                                    padding: EdgeInsets.fromLTRB(screenWidth * 0.05, 0, screenWidth * 0.05, 0),
                                                    alignment: Alignment.topCenter,
                                                    child: ListView.builder(
                                                      itemCount: bookmarks.length,
                                                      itemBuilder: (BuildContext context, int index){
                                                        return BookmarkInfo(
                                                            name: bookmarks[index],
                                                            team: "ScottyLabs",
                                                            bio: "[Bio]"
                                                        );
                                                      },
                                                    ),
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

class BookmarkInfo extends StatelessWidget {
  String name;
  String team;
  String bio;

  BookmarkInfo({this.name, this.team, this.bio});

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
                        name,
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
                      onPressed: () {},
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