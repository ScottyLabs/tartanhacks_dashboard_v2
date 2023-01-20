import 'package:flutter/material.dart';

class CurvedCorner extends CustomPainter {
  Color color;
  CurvedCorner({this.color});
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = color
      ..strokeWidth = 15;
    var path = Path();
    path.moveTo(0, size.height);
    path.cubicTo(.15*size.width, .3*size.height, size.width, size.height, size.width, 0);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);
    canvas.drawPath(path, paint);
  }
  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}