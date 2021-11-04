import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'custom_widgets.dart';

class ScanConfigPage extends StatelessWidget {
  Widget build(BuildContext context) {
    final mqData = MediaQuery.of(context);
    final screenHeight = mqData.size.height;
    final screenWidth = mqData.size.width;

    return Scaffold(
      body: Container(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget> [
                TopBar(backflag: true,),
                Stack(
                  children: [
                    Column(
                        children:[
                          SizedBox(height:screenHeight * 0.05),
                          CustomPaint(
                              size: Size(screenWidth, screenHeight * 0.75),
                              painter: CurvedTop(
                                  color1: Theme.of(context)
                                      .colorScheme
                                      .secondaryVariant,
                                  color2:
                                  Theme.of(context).colorScheme.primary,
                                  reverse: true)),
                        ]
                    ),
                    Container(
                        alignment: Alignment.center,
                        height: screenHeight * 0.78,
                        padding: EdgeInsets.fromLTRB(15, 20, 15, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ScanConfigBox()
                          ],
                        ))
                  ],
                ),
              ]
          )
      ),
    );
  }
}

class ScanConfigBox extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return GradBox(
      alignment: Alignment.topLeft,
      padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
      curvature: 15,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            "SCAN CONFIG",
            style: Theme.of(context).textTheme.headline2,
            textAlign: TextAlign.left,
          ),
          SizedBox(height: 40,),
          Text(
            "Check In Item",
            style: Theme.of(context).textTheme.headline3,
          ),
          SizedBox(height: 15,),
          DropdownButtonFormField(items: [DropdownMenuItem(
            child: Text("Ctrl+F - Working with your team",
              style: Theme.of(context).textTheme.bodyText2,
            ),
          )]),
          SizedBox(height: 25,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "View History",
                style: Theme.of(context).textTheme.headline3,
              ),
              Transform.scale(
                scale: 1.5,
                child: Checkbox(
                    side: BorderSide(
                        color: Theme.of(context).colorScheme.primary,
                        width: 2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    value: false,
                    onChanged: (val){}),
              )
            ],
          ),
          SizedBox(height: 25,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Self-checkin",
                style: Theme.of(context).textTheme.headline3,
              ),
              Transform.scale(
                scale: 1.5,
                child: Checkbox(
                    side: BorderSide(
                        color: Theme.of(context).colorScheme.primary,
                        width: 2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    value: false,
                    onChanged: (val){}),
              )
            ],
          ),
          SizedBox(height: 40,),
          Align(
            alignment: Alignment.center,
            child: SizedBox(
              height: 45,
              width: 160,
              child: SolidButton(
                text: "Confirm",
                onPressed: (){},
              ),
            ),
          )
        ],
      ),
    );
  }
}

