import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../custom_widgets.dart';
import 'new.dart';

class EventHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final mqData = MediaQuery.of(context);
    final screenHeight = mqData.size.height;
    final screenWidth = mqData.size.width;

    return Scaffold(
        body: Container(
            child: SingleChildScrollView(
                child: ConstrainedBox(
                    constraints: BoxConstraints(maxHeight: screenHeight),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TopBar(backflag: true),
                        Stack(
                          children: [
                            Column(children: [
                              SizedBox(height: screenHeight * 0.05),
                              CustomPaint(
                                  size: Size(screenWidth, screenHeight * 0.75),
                                  painter: CurvedTop(
                                      color1:
                                          Theme.of(context).colorScheme.primary,
                                      color2: Theme.of(context)
                                          .colorScheme
                                          .secondaryVariant)),
                            ]),
                            Column(children: [
                              SizedBox(height: 12),
                              GradBox(
                                width: screenWidth * 0.9,
                                height: 60,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => createState()),
                                  );
                                },
                                child: Text(
                                  "CREATE NEW EVENT",
                                  style: Theme.of(context).textTheme.headline2,
                                ),
                              )
                            ])
                          ],
                        )
                      ],
                    )))));
  }
}
