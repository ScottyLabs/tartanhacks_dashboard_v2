import 'package:flutter/material.dart';

void errorDialog(context, String title, String response) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(title, style: Theme.of(context).textTheme.headline1),
        content: Text(response, style: Theme.of(context).textTheme.bodyText2),
        actions: <Widget>[
          TextButton(
            child: Text(
              "OK",
              style: Theme.of(context).textTheme.headline4,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}