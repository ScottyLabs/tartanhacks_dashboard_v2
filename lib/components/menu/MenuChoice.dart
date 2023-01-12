import 'package:flutter/material.dart';

class MenuChoice extends StatelessWidget {
  final IconData icon;
  final String text;
  final Function onTap;
  const MenuChoice({this.icon, this.text, this.onTap});
  @override
  Widget build(BuildContext context) {
    final mqData = MediaQuery.of(context);
    final screenWidth = mqData.size.width;
    Color color = Theme.of(context).colorScheme.error;
    return Container(
        width: screenWidth/4,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
        child: Column(
            children: [
              RawMaterialButton(
                onPressed: onTap,
                elevation: 2.0,
                fillColor: color,
                child: Icon(
                  icon,
                  size: 40.0,
                  color: Theme.of(context).colorScheme.onError,
                ),
                padding: const EdgeInsets.all(12),
                shape: const CircleBorder(),
              ),
              Text(text,
                style: TextStyle(
                    color: color,
                    fontSize: 14
                ),
              )
            ]
        )
    );
  }
}