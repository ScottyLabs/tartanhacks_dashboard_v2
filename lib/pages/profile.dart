import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'custom_widgets.dart';

class Profile extends StatelessWidget {

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
                        TopBar(backflag: true),
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
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("HACKER PROFILE", style: Theme.of(context).textTheme.headline1,),
                                        Container(
                                          height: 150,
                                          padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                                          child: Row(
                                            children: [
                                              ClipRRect(
                                                borderRadius: BorderRadius.circular(10),
                                                child:
                                                  Image(
                                                    image: AssetImage("lib/logos/defaultpfp.PNG"),
                                                  )
                                              ),
                                              SizedBox(width:25),
                                              Expanded(
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text("FIRSTNAME",
                                                      style: Theme.of(context).textTheme.headline3
                                                    ),
                                                    Text("LASTNAME",
                                                        style: Theme.of(context).textTheme.headline3
                                                    ),
                                                    Text("[TEAM NAME]",
                                                        style: Theme.of(context).textTheme.bodyText2
                                                    ),
                                                  ],
                                                )
                                              )
                                            ],
                                          )
                                        ),
                                        SolidButton(
                                          text: "  Link to GitHub  ",
                                        ),
                                        SolidButton(
                                          text: "  View Resume  ",
                                        ),
                                        SizedBox(height: 8),
                                        Text("Bio:",
                                            style: Theme.of(context).textTheme.bodyText2
                                        ),
                                        Container(
                                          height: 100,
                                          padding: EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            color: darken(Theme.of(context).colorScheme.surface, 0.02),
                                            borderRadius: BorderRadius.circular(15),
                                          ),
                                          child: Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit, "
                                              "sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. "
                                              "Ut enim ad minim veniam, quis nostrud exercitation ullamco "
                                              "laboris nisi ut aliquip ex ea commodo consequat.",
                                            style: Theme.of(context).textTheme.bodyText2,
                                            maxLines: 3,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        SizedBox(height: 8),
                                        SolidButton(
                                          text: "Edit Information",
                                        )
                                      ],
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