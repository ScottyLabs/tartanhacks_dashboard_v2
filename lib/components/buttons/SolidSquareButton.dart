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
              MaterialStateProperty.all(Theme.of(context).colorScheme.primary),
          backgroundColor:
              MaterialStateProperty.all(Theme.of(context).colorScheme.primary),
          shadowColor: MaterialStateProperty.all(
              Theme.of(context).colorScheme.secondaryContainer),
          shape: MaterialStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
          fixedSize: MaterialStateProperty.all<Size>(const Size.square(10)),
          elevation: MaterialStateProperty.all(5)),
      child: const SizedBox(),
    );
  }
}
