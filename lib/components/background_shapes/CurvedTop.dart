import 'package:flutter/material.dart';

class CurvedTop extends CustomPainter {
  Color color1;
  Color color2;
  bool reverse;
  CurvedTop({this.color1, this.color2, this.reverse = false});
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = color1
      ..strokeWidth = 15
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors:[color1, color2],
      ).createShader(!reverse ? Rect.fromLTRB(0, 0, size.width, size.height) : Rect.fromLTRB(size.width, size.height, 0, 0));
    var path = Path();
    double curveHeight = size.height * (0.3);
    path.moveTo(0, curveHeight);
    path.cubicTo(.03*size.width, .17*curveHeight, .97*size.width, .83*curveHeight, size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    canvas.drawPath(path, paint);
  }
  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}