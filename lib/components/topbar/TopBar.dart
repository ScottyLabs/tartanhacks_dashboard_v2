import 'package:flutter/material.dart';
import 'package:thdapp/components/menu/MenuButton.dart';
import 'package:thdapp/components/menu/MenuOverlay.dart';
import 'package:thdapp/components/menu/SponsorMenuOverlay.dart';
import './CurvedCorner.dart';
import './BackFlag.dart';
import './HomeButton.dart';
import './TextLogo.dart';

class TopBar extends StatelessWidget {
  final bool backflag;
  final bool isSponsor;
  const TopBar({ this.backflag = false, this.isSponsor = false });
  @override
  Widget build(BuildContext context) {
    final mqData = MediaQuery.of(context);
    final screenHeight = mqData.size.height;
    final screenWidth = mqData.size.width;
    double safe_padding = mqData.padding.top;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(alignment: Alignment.topLeft, children: [
          CustomPaint(
            size: Size(screenWidth * 0.65, screenHeight * 0.2),
            painter: CurvedCorner(color: Theme.of(context).colorScheme.primary, padding: safe_padding),
          ),
          Container(
              width: screenWidth * 0.65,
              height: screenHeight * 0.2,
              alignment: Alignment.topLeft,
              padding: EdgeInsets.fromLTRB(10, safe_padding + 25, 0, 0),
              child: TextLogo(
                  color: Theme.of(context).colorScheme.onSecondary,
                  width: screenWidth,
                  height: 50)),
          if (backflag)
            Container(
                width: screenWidth * 0.65,
                height: screenHeight * 0.2,
                alignment: Alignment.bottomLeft,
                child: BackFlag()),
        ]),
        Container(
            width: screenWidth * 0.35,
            alignment: Alignment.topCenter,
            padding: EdgeInsets.fromLTRB(0, safe_padding + 20, 0, 0),
            child: backflag
                ? null
                : Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                    HomeButton(isSponsor),
                    const SizedBox(width: 10),
                    MenuButton(onTap: () {
                      if (isSponsor) {
                        Overlay.of(context).insert(sponsorMenuOverlay(context));
                      } else {
                        Overlay.of(context).insert(menuOverlay(context));
                      }
                    }),
                    const SizedBox(width: 17)
                  ]))
      ],
    );
  }
}
