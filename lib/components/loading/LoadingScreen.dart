import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final mqData = MediaQuery.of(context);
    final screenHeight = mqData.size.height;
    final screenWidth = mqData.size.width;

    return Scaffold(
        body: Container(
            height: screenHeight,
            width: screenWidth,
            alignment: Alignment.center,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children:[
                  Container(
                      height: screenHeight*0.35,
                      width: screenWidth,
                      alignment: Alignment.topCenter,
                      padding: const EdgeInsets.fromLTRB(0, 20, 0, 10),
                      child: Image.asset("lib/logos/thLogoDark.png")
                  ),
                  Text("Tartanhacks",
                    style: Theme.of(context).textTheme.headline1,
                  ),
                  Text("by Scottylabs",
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                  const SizedBox(height: 25),
                  CircularProgressIndicator(color: Theme.of(context).colorScheme.primary,)
                ]
            )
        )
    );
  }
}