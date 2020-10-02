import 'package:flutter/material.dart';
import 'constants.dart';

void mySnack(BuildContext context, String message) {
  Scaffold.of(context).showSnackBar(SnackBar(
    content: Text(
      '$message',
      style: TextStyle(color: mainColor),
    ),
    backgroundColor: Colors.white,
    action: SnackBarAction(
        label: "Dismiss",
        onPressed: () {
          Scaffold.of(context).hideCurrentSnackBar();
        },
        textColor: Colors.red),
  ));
}
