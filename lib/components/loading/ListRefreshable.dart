import 'package:flutter/material.dart';

class ListRefreshable extends StatelessWidget {
  Widget child;

  ListRefreshable({ required this.child });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ListView(
          shrinkWrap: true,
          children: const [
            SizedBox(width: 100, height: 500,)
          ],
        ),
        child
      ],
    );
  }
}
