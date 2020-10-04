import 'package:flutter/material.dart';


final apiBase = "http://104.156.233.57:5000/";
final mainColor = Color(0xff4864E6);
final backgroundColor = Color(0XffF2F4FF);

final myTextStyle = TextStyle(
  color: Colors.white54,
  fontFamily: 'OpenSans',
);

final titleTextStyle = TextStyle(
  color: Colors.white,
  fontWeight: FontWeight.bold,
  fontFamily: 'OpenSans',
);

final majorInputBoxStyle = BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(10.0),
  boxShadow: [
    BoxShadow(
      color: Colors.black12,
      blurRadius: 6.0,
      offset: Offset(0, 2),
    ),
  ],
);

