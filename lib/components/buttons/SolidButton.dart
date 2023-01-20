import 'package:flutter/material.dart';

class SolidButton extends StatelessWidget{
  String text;
  Function onPressed;
  Widget child;
  Color color;
  Color textColor;

  SolidButton({this.text, this.onPressed, this.child, this.color, this.textColor});

  @override
  Widget build(BuildContext context) {
    if (color == null) {
      color = Theme.of(context).colorScheme.tertiary;
      textColor = Theme.of(context).colorScheme.onTertiary;
    } else if (color == Theme.of(context).colorScheme.tertiaryContainer) {
      textColor = Theme.of(context).colorScheme.onTertiaryContainer;
    } else if (color == Theme.of(context).colorScheme.primary) {
      textColor = Theme.of(context).colorScheme.onPrimary;
    } else if (color == Theme.of(context).colorScheme.secondary) {
      textColor = Theme.of(context).colorScheme.onSecondary;
    }
    return ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all(color),
            backgroundColor: MaterialStateProperty.all(color),
            shadowColor: MaterialStateProperty.all(Theme.of(context).colorScheme.secondaryVariant),
            shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
            elevation: MaterialStateProperty.all(5)
        ),
        child: child ?? Text(text,
          style: TextStyle(
              fontSize:16.0,
              fontWeight: FontWeight.w600,
              color: textColor
          ),
          overflow: TextOverflow.fade,
          softWrap: false,
        )
    );
  }
}