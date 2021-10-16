import 'package:charcode/html_entity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'custom_widgets.dart';

class Sponsors extends StatelessWidget {

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
                                ], // children
                              ),
                            Column(
                              children:[
                                Container(
                                  alignment: Alignment.topLeft,
                                  padding: EdgeInsets.fromLTRB(35, 0, 10, 0),
                                  child: Text("HI [SPONSOR NAME], WELCOME BACK", style: Theme.of(context).textTheme.headline1),
                                )
                              ], // children
                            ),
                            Column(
                              children: [
                                Container(
                                    alignment: Alignment.centerLeft,
                                    padding: EdgeInsets.fromLTRB(screenHeight * 0.032, screenHeight * 0.3, 0, 0),
                                    child: Text(
                                      "Search",
                                      textAlign: TextAlign.left,
                                      style: Theme.of(context).textTheme.headline3
                                  )
                                ),
                                Container(
                                    padding: EdgeInsets.fromLTRB(screenHeight * 0.015, 0, screenHeight * 0.015, 0),
                                      child: TextField(
                                        decoration: InputDecoration(fillColor: Colors.white, filled: true, border: InputBorder.none),
                                        style: Theme.of(context).textTheme.bodyText2,
                                        enableSuggestions: false,
                                      ),
                                ),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(screenWidth * 0.73, screenWidth * 0.01, 0 , 0),
                                    child: GradBox(
                                      width: screenWidth*0.2,
                                      height: screenHeight*0.08,
                                      child: Text(String.fromCharCode(($crarr)), style: Theme.of(context).textTheme.headline1)
                                    ),
                                  ),
                                ]
                                ),

                            Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.fromLTRB(0, screenHeight * 0.52, 0, 0),
                                  alignment: Alignment.bottomCenter,
                                    child: GradBox(
                                      width: screenWidth*0.95,
                                      height: screenHeight*0.15,
                                      child: Column(
                                        children: [
                                        Text(
                                          "[Student A name]",
                                          textAlign: TextAlign.left,
                                          style: Theme.of(context).textTheme.headline1,
                                        ),
                                        Text(
                                          "Team:",
                                          textAlign: TextAlign.left,
                                          style: TextStyle(fontSize: screenHeight * 0.02),
                                        ),
                                        Text(
                                          "[Bio]",
                                          textAlign: TextAlign.left,
                                          style: TextStyle(fontSize: screenHeight * 0.02),
                                        ),
                                      ]
                                      )
                                    )
                                )
                            ] //children
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
