import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme_changer.dart';
import 'dart:math';

class TextLogo extends StatelessWidget {
  final Color color;
  final double width;
  final double height;

  const TextLogo({ required this.color, required this.width, required this.height });

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeChanger>(context, listen: false);
    return SizedBox(
        width: width,
        height: height,
        child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children:[
              SizedBox(
                  height: height,
                  width: min(width*0.20, 50),
                  child: themeProvider.getTheme==lightTheme ? Image.asset("lib/logos/thLogoLight_small.png")
                      : Image.asset("lib/logos/thLogoLight_small.png")
              ),
              Text("TartanHacks ",
                  style: TextStyle(
                    fontSize: min(width*0.1, 30),
                    fontWeight: FontWeight.w600,
                    color: color,
                  )
              )
            ]
        )
    );
  }
}