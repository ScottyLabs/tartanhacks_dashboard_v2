import 'package:charcode/html_entity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'custom_widgets.dart';

class Bookmarks extends StatelessWidget {

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
                              )
                            ] //children
                        )
                      ] // children
                  ),
                )
            )
        )
    );
  }
}
