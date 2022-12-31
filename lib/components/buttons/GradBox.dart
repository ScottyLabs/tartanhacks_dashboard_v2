import 'package:flutter/material.dart';

class GradBox extends StatelessWidget{
  final double width;
  final double height;
  final double curvature;
  final Widget child;
  final bool reverse;
  final EdgeInsets padding;
  final Function onTap;
  final Alignment alignment;
  const GradBox({this.width, this.height, this.child, this.reverse=false,
    this.padding, this.onTap, this.alignment, this.curvature=25});

  @override
  Widget build(BuildContext context) {
    Color color1 = Theme.of(context).colorScheme.surface;
    Color color2 = Theme.of(context).colorScheme.primaryVariant;
    Color shadow = Theme.of(context).colorScheme.onBackground;
    return Container(
        width: width,
        height: height,
        alignment: alignment ?? Alignment.center,
        padding: padding ?? const EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: Colors.white,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: !reverse ? [color1, color2] : [color2, color1],
            ),
            borderRadius: BorderRadius.circular(curvature),
            boxShadow: [BoxShadow(
                color: shadow,
                offset: const Offset(0.0, 5.0),
                blurRadius: 5.0)]
        ),
        child: (onTap==null) ? child : InkWell(onTap: onTap, child: child)
    );
  }
}