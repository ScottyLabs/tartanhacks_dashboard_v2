import 'package:flutter/material.dart';
import 'package:thdapp/components/buttons/GradBox.dart';

class MenuButton extends StatelessWidget {
  final Function onTap;
  final IconData icon;

  const MenuButton({this.onTap, this.icon});
  @override
  Widget build(BuildContext context) {
    return Material(
        type: MaterialType.button,
        color: const Color(0x00000000),
        child: GradBox(
            width: 55,
            height: 55,
            padding: const EdgeInsets.all(0),
            child: Icon(icon ?? Icons.menu,
                color: Theme.of(context).colorScheme.onSurface,
                size: 35
            ),
            onTap: onTap
        )
    );
  }
}