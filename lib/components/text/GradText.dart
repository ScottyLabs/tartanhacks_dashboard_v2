import 'package:flutter/material.dart';

class GradText extends StatelessWidget {
  final String text;
  final Color color1;
  final Color color2;
  final double size;
  const GradText({this.text, this.size, this.color1, this.color2});
  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) =>
          LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors:[color1, color2]
          ).createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height),
          ),
      child: Text(text,
        style: TextStyle(
            color: Colors.white,
            fontSize: size,
            fontWeight: FontWeight.bold
        ),
      ),
    );
  }
}