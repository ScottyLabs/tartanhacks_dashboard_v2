import 'package:flutter/material.dart';
import 'package:thdapp/pages/home.dart';
import 'package:thdapp/pages/sponsors.dart';
import '../buttons/GradBox.dart';

class HomeButton extends StatelessWidget {
  final bool isSponsor;

  const HomeButton(this.isSponsor);

  @override
  Widget build(BuildContext context) {
    return Material(
        type: MaterialType.button,
        color: const Color(0x00000000),
        child: GradBox(
            width: 55,
            height: 55,
            padding: const EdgeInsets.all(0),
            child: Icon(Icons.home,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                size: 35
            ),
            onTap: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => isSponsor ? Sponsors() : Home(),),
                      (route) => false
              );
            }
        )
    );
  }
}