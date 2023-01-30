import 'package:flutter/material.dart';
import 'package:decorated_icon/decorated_icon.dart';
import './FlagPainter.dart';

class BackFlag extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 80,
        height: 35,
        child: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Stack(
                alignment: Alignment.centerRight,
                children: [
                  CustomPaint(
                    size: const Size(80, 35),
                    painter: FlagPainter(color: Theme.of(context).colorScheme.primary),
                  ),
                  Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                      child: DecoratedIcon(Icons.arrow_back_ios_rounded,
                        size: 25,
                        color: Theme.of(context).scaffoldBackgroundColor,
                        shadows: [
                          BoxShadow(
                            blurRadius: 6.0,
                            color: darken(Theme.of(context).colorScheme.shadow, 0.01),
                            offset: const Offset(3.0, 0),
                          ),
                        ],
                      )
                  ),
                  Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 22, 0),
                      child: DecoratedIcon(Icons.arrow_back_ios_rounded,
                        size: 25,
                        color: Theme.of(context).scaffoldBackgroundColor,
                        shadows: [
                          BoxShadow(
                            blurRadius: 6.0,
                            color: darken(Theme.of(context).colorScheme.shadow, 0.01),
                            offset: const Offset(3.0, 0),
                          ),
                        ],
                      )
                  )
                ]
            )
        )
    );
  }
}

Color darken(Color color, [double amount = .1]) {
  assert(amount >= 0 && amount <= 1);
  final hsl = HSLColor.fromColor(color);
  final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
  return hslDark.toColor();
}