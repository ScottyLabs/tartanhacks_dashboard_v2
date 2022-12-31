import 'package:flutter/material.dart';
import 'package:thdapp/components/background_shapes/CurvedTop.dart';
import 'package:thdapp/components/buttons/GradBox.dart';
import 'package:thdapp/components/buttons/SolidButton.dart';
import 'package:thdapp/components/topbar/TopBar.dart';
import 'custom_widgets.dart';

class ScanConfigPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final mqData = MediaQuery.of(context);
    final screenHeight = mqData.size.height;
    final screenWidth = mqData.size.width;

    return Scaffold(
      body: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget> [
            const TopBar(backflag: true,),
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
                    padding: const EdgeInsets.fromLTRB(15, 20, 15, 0),
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
      ),
    );
  }
}

class ScanConfigBox extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return GradBox(
      alignment: Alignment.topLeft,
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
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
          const SizedBox(height: 40,),
          Text(
            "Check In Item",
            style: Theme.of(context).textTheme.headline3,
          ),
          const SizedBox(height: 15,),
          DropdownButtonFormField(items: [DropdownMenuItem(
            child: Text("Ctrl+F - Working with your team",
              style: Theme.of(context).textTheme.bodyText2,
            ),
          )], onChanged: (value) {  },),
          const SizedBox(height: 25,),
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
          const SizedBox(height: 25,),
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
          const SizedBox(height: 40,),
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

