import 'package:flutter/material.dart';

class CurvedCorner extends CustomPainter {
  Color color;
  double padding;
  CurvedCorner({ required this.color, this.padding = 0});
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = color
      ..strokeWidth = 15;
    var path = Path();
    path.moveTo(0, size.height + padding * 0.5);
    path.cubicTo(.15*size.width, .3*size.height + padding * 0.5, size.width, size.height + padding, size.width + padding, 0);
    path.lineTo(size.width + padding, 0);
    path.lineTo(0, 0);
    canvas.drawPath(path, paint);
  }
  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}