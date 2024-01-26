import 'package:flutter/material.dart';

class MenuChoice extends StatelessWidget {
  final IconData icon;
  final String text;
  final void Function()? onTap;
  const MenuChoice({ required this.icon, required this.text, required this.onTap});
  @override
  Widget build(BuildContext context) {
    final mqData = MediaQuery.of(context);
    final screenWidth = mqData.size.width;
    return Container(
        width: screenWidth/4,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
        child: Column(
            children: [
              RawMaterialButton(
                onPressed: onTap,
                elevation: 2.0,
                fillColor: Theme.of(context).colorScheme.errorContainer,
                child: Icon(
                  icon,
                  size: 40.0,
                  color: Theme.of(context).colorScheme.onErrorContainer,
                ),
                padding: const EdgeInsets.all(12),
                shape: const CircleBorder(),
              ),
              Text(text,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.errorContainer
                ),
              )
            ]
        )
    );
  }
}