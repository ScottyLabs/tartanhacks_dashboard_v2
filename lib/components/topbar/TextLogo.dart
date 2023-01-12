import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme_changer.dart';
import 'dart:math';

class TextLogo extends StatelessWidget {
  final Color color;
  final double width;
  final double height;

  const TextLogo({this.color, this.width, this.height});

  @override
  Widget build(BuildContext context) {
    var _themeProvider = Provider.of<ThemeChanger>(context, listen: false);
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
                  child: _themeProvider.getTheme==lightTheme ? Image.asset("lib/logos/thLogoDark.png")
                      : Image.asset("lib/logos/thLogoDark.png")
              ),
              Text(" Tartanhacks ",
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