import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'custom_widgets.dart';
import 'package:charcode/charcode.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'project_submission.dart';
import 'profile.dart';
import 'leaderboard.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final mqData = MediaQuery.of(context);
    final screenHeight = mqData.size.height;
    final screenWidth = mqData.size.width;

    return Scaffold(
      body: Container(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget> [
                TopBar(),
                Stack(
                  children: [
                    Column(
                      children:[
                        SizedBox(height:screenHeight * 0.05),
                        CustomPaint(
                            size: Size(screenWidth, screenHeight * 0.75),
                            painter: CurvedTop(color1: Theme.of(context).colorScheme.primary,
                                color2: Theme.of(context).colorScheme.secondaryVariant)
                        ),
                      ]
                    ),
                    Column(
                      children: [
                        Container(
                            alignment: Alignment.topLeft,
                            padding: EdgeInsets.fromLTRB(30, 0, 20, 0),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("HACKING TIME LEFT", style: Theme.of(context).textTheme.headline1),
                                  SizedBox(height: 8),
                                  CountdownTimer(
                                    endTime: 1641024000000,
                                    textStyle: TextStyle(
                                        fontSize: 35.0,
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context).colorScheme.secondary),
                                  ),
                                ]
                            )
                        ),
                        Container(
                          width: screenWidth,
                          height: screenHeight * 0.2,
                          alignment: Alignment.bottomCenter,
                          padding: EdgeInsets.all(15),
                          child: Text("Swipe to see all the places where the\n"
                              + String.fromCharCode($larr) + "hacking is happening" + String.fromCharCode(($rarr)),
                            style: Theme.of(context).textTheme.bodyText1,
                            textAlign: TextAlign.center,
                          )
                        ),
                        CarouselSlider(
                          items: [
                            GradBox(
                                width: 190,
                                height: 190,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text("Hi [Two Line User Name]", style: Theme.of(context).textTheme.headline4),
                                    Text("Welcome to [Event Name]", style: Theme.of(context).textTheme.bodyText2),
                                    SolidButton(
                                      text: "View Profile",
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) =>
                                              Profile()),
                                        );
                                      },
                                    )
                                  ]
                                )
                            ),
                            GradBox(
                                width: 190,
                                height: 190,
                                child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text("Swag Points", style: Theme.of(context).textTheme.headline4),
                                      Text("Points Earned: 0", style: Theme.of(context).textTheme.bodyText2),
                                      SolidButton(
                                        text: "Leaderboard",
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context) =>
                                                Leaderboard()),
                                          );
                                        },
                                      ),
                                      SolidButton(text: "Check In", onPressed: null,)
                                    ]
                                )
                            ),
                            GradBox(
                                width: 190,
                                height: 190,
                                child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      SolidButton(text: "Discord", onPressed: null,),
                                      SolidButton(text: "Hopin", onPressed: null,),
                                      SolidButton(text: "TH Website", onPressed: null,)
                                    ]
                                )
                            ),
                          ],
                          options: CarouselOptions(
                            height: 175.0,
                            enlargeCenterPage: false,
                            autoPlayCurve: Curves.fastOutSlowIn,
                            enableInfiniteScroll: true,
                            viewportFraction: 0.5,
                          ),
                        ),
                        SizedBox(height: 20),
                        GradBox(
                          width: 360,
                          height: 75,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) =>
                                  ProjSubmit()),
                            );
                          },
                          child: Text(
                            "VIEW YOUR PROJECT",
                            style: Theme.of(context).textTheme.headline1,
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ]
          )
      ),
    );
  }
}