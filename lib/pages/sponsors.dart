import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'custom_widgets.dart';

class Sponsors extends StatelessWidget {
  List people = ["Anuda Weerasinghe", "Joyce Hong", "Gram Liu", "Elise Chapman",
    "Catherine Liu", "Susan Ni", "Alice", "Bob", "Carol", "Dave"];

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
                                ]
                            ),
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

class LBRow extends StatelessWidget {
  int place;
  String name;
  int points;


  LBRow({this.place, this.name, this.points});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 80,
              alignment: Alignment.center,
              child: Text(place.toString(), style: Theme.of(context).textTheme.headline1,),
            ),
            Expanded(child: SolidButton(text: name, onPressed: null)),
            Container(
                width: 80,
                alignment: Alignment.center,
                child: Text("$points pts", style: Theme.of(context).textTheme.bodyText2,)
            )
          ],
        )
    );
  }
}