import 'package:flutter/material.dart';
import 'dart:math';

class FlagPainter extends CustomPainter {
  Color color;
  FlagPainter({ required this.color });
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = color
      ..strokeWidth = 15;
    var path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width-(size.height/2), 0);
    Rect arcRect = Rect.fromCircle(center: Offset(size.width-(size.height/2), size.height/2), radius: size.height/2);
    path.arcTo(arcRect, -pi/2, pi, true);
    path.lineTo(0, size.height);
    path.lineTo(0,0);
    canvas.drawPath(path, paint);
  }
  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}