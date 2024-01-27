import 'package:flutter/material.dart';

import 'background_shapes/CurvedTop.dart';
import 'topbar/TopBar.dart';

class DefaultPage extends StatelessWidget {
  final Widget child;
  final bool reverse;
  final bool backflag;
  final bool isSponsor;

  const DefaultPage({ 
    required this.child, 
    this.reverse=true, 
    this.backflag=false, 
    this.isSponsor=false
  });

  @override
  Widget build(BuildContext context) {
    final mqData = MediaQuery.of(context);
    final screenHeight = mqData.size.height;
    final screenWidth = mqData.size.width;
    return Scaffold(
        body: SingleChildScrollView(
            child: ConstrainedBox(
                constraints: BoxConstraints(
                    maxHeight: screenHeight
                ),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TopBar(backflag: backflag, isSponsor: isSponsor),
                      Stack(
                          children: [
                            Column(
                                children: [
                                  SizedBox(height: screenHeight * 0.05),
                                  CustomPaint(
                                      size: Size(screenWidth, screenHeight * 0.75),
                                      painter: CurvedTop(
                                          color1: Theme.of(context).colorScheme.primary,
                                          color2: Theme.of(context).colorScheme.secondary,
                                          reverse: reverse
                                      )
                                  ),
                                ]
                            ),
                            Container(
                                child: child
                            )
                          ]
                      )
                    ]
                )
            )
        )
    );
  }
}