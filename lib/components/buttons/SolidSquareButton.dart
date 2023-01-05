import 'package:flutter/material.dart';

class SolidSquareButton extends StatelessWidget{
  final String image;
  final Function onPressed;

  const SolidSquareButton({this.image, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
          foregroundColor: MaterialStateProperty.all(Theme.of(context).colorScheme.primary),
          backgroundColor: MaterialStateProperty.all(Theme.of(context).colorScheme.primary),
          shadowColor: MaterialStateProperty.all(Theme.of(context).colorScheme.secondaryVariant),
          shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
          fixedSize: MaterialStateProperty.all<Size>(const Size.square(10)),
          elevation: MaterialStateProperty.all(5)
      ),
    );
  }
}