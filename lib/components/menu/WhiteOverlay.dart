import 'package:flutter/material.dart';

class WhiteOverlay extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    /*
    var paint = Paint()
      ..color = Colors.white60
      ..strokeWidth = 15;
    */
    var paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 15
      ..shader = const LinearGradient(
        begin: Alignment.bottomLeft,
        end: Alignment.topRight,
        colors:[Colors.white24, Colors.white],
      ).createShader(Rect.fromLTRB(0, 0, size.width, size.height));
    var path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.lineTo(0,0);
    canvas.drawPath(path, paint);
  }
  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}