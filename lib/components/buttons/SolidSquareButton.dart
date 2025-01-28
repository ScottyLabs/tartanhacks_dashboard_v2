import 'package:flutter/material.dart';

class SolidSquareButton extends StatelessWidget {
  final String image;
  final void Function() onPressed;

  const SolidSquareButton({required this.image, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
          foregroundColor:
              WidgetStateProperty.all(Theme.of(context).colorScheme.primary),
          backgroundColor:
              WidgetStateProperty.all(Theme.of(context).colorScheme.primary),
          shadowColor: WidgetStateProperty.all(
              Theme.of(context).colorScheme.secondaryContainer),
          shape: WidgetStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
          fixedSize: WidgetStateProperty.all<Size>(const Size.square(10)),
          elevation: WidgetStateProperty.all(5)),
      child: const SizedBox(),
    );
  }
}
