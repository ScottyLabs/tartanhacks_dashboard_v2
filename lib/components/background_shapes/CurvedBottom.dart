import 'package:flutter/material.dart';

class CurvedBottom extends CustomPainter {
  Color color1;
  Color color2;
  CurvedBottom({this.color1, this.color2});
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = color1
      ..strokeWidth = 15
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors:[color1, color2],
      ).createShader(Rect.fromLTRB(0, 0, size.width, size.height));
    var path = Path();
    double curveOffset = size.height * (3/5);
    double curveHeight = size.height - curveOffset;
    path.moveTo(0, size.height);
    path.cubicTo(.03*size.width, curveOffset+.17*curveHeight, .97*size.width, curveOffset+.83*curveHeight, size.width, curveOffset);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);
    canvas.drawPath(path, paint);
  }
  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}