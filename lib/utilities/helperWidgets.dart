import 'package:flutter/material.dart';
import 'constants.dart';


/// A custom snack widget of the main Color scheme
void mySnack(BuildContext context, String message) {
  Scaffold.of(context).showSnackBar(SnackBar(
    content: Text(
      '$message',
      style: TextStyle(color: mainColor),
    ),
    backgroundColor: Colors.white,
    behavior: SnackBarBehavior.floating,
    action: SnackBarAction(
        label: "Dismiss",
        onPressed: () {
          Scaffold.of(context).hideCurrentSnackBar();
        },
        textColor: Colors.red),
  ));
}
