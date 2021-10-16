import 'package:charcode/html_entity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'custom_widgets.dart';

class Sponsors extends StatelessWidget {
  List students = ["Student A", "Student B", "Student C", "Student D"];
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
                                              name: students[index],
                                              team: 'A',
                                              bio: 'test'
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

class InfoTile extends StatelessWidget {
  String name;
  String team;
  String bio;

  InfoTile({this.name, this.team, this.bio});

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
                  width: 185,
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
                Icon(
                  Icons.bookmark,
                  color: Theme.of(context).colorScheme.primary,
                  size: 40.0,
                ),
              ],
            )
        )
    );
  }
}
