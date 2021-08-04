import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'custom_widgets.dart';

class Leaderboard extends StatelessWidget {
  List people = ["Anuda Weerasinghe", "Joyce Hong", "Gram Liu", "Elise Chapman",
    "Catherine Liu", "Susan Ni", "Alice", "Bob", "Carol", "Dave"];

  @override
  Widget build(BuildContext context) {
    final mqData = MediaQuery.of(context);
    final screenHeight = mqData.size.height;
    final screenWidth = mqData.size.width;

    return Scaffold(
        body:  Container(
            child: SingleChildScrollView(
                child: ConstrainedBox(
                    constraints: BoxConstraints(
                        maxHeight: screenHeight
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
                            TopBar(backflag: true),
                            SolidButton(
                              text: "   View my position   ",
                            )
                          ],
                        ),
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
                            Container(
                                alignment: Alignment.center,
                                padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                                child: GradBox(
                                    width: screenWidth*0.9,
                                    height: screenHeight*0.75,
                                    padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                                    alignment: Alignment.topLeft,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("LEADERBOARD", style: Theme.of(context).textTheme.headline1),
                                        Text("Scroll to see the whole board!",
                                          style: Theme.of(context).textTheme.bodyText2,
                                        ),
                                        Expanded(
                                          child: Container(
                                            alignment: Alignment.center,
                                            child: ListView.builder(
                                              itemCount: people.length,
                                              itemBuilder: (BuildContext context, int index){
                                                return LBRow(
                                                    place: (index+1)*100,
                                                    name: people[index],
                                                    points: 5000
                                                );
                                              },
                                            ),
                                          )
                                        )
                                      ]
                                    )
                                )
                            )
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
      padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
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