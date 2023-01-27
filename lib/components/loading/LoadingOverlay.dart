import 'package:flutter/material.dart';
import 'package:thdapp/components/loading/WhiteOverlayLight.dart';

OverlayEntry LoadingOverlay(BuildContext context) {
  final screenSize = MediaQuery.of(context).size;
  return OverlayEntry(
      builder: (context) => Positioned(
          child: Stack(
            alignment: Alignment.center,
            children: [
              CustomPaint(
                  size: screenSize,
                  painter: WhiteOverlayLight()
              ),
              Container(
                  width: screenSize.width,
                  height: screenSize.height,
                  alignment: Alignment.center,
                  child: CircularProgressIndicator(color: Theme.of(context).colorScheme.error,)
              )
            ],
          )
      )
  );
}