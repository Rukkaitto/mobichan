import 'package:flutter/material.dart';

final ThemeData theme = ThemeData(
  brightness: Brightness.dark,
  textTheme: TextTheme(
    headline1: TextStyle(
      color: Colors.white,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
    headline2: TextStyle(
      color: Colors.white,
      fontSize: 15,
      fontWeight: FontWeight.w600,
    ),
    subtitle1: TextStyle(
      color: Color(0xFF888888),
      fontWeight: FontWeight.w600,
    ),
    subtitle2: TextStyle(
      color: Color(0xFF888888),
    ),
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: Color(0xFF202020),
    elevation: 0,
  ),
  scaffoldBackgroundColor: Color(0xFF202020),
  cardColor: Color(0xFF2E2E2E),
  canvasColor: Color(0xFF202020),
  pageTransitionsTheme: PageTransitionsTheme(
    builders: {
      TargetPlatform.android: CupertinoPageTransitionsBuilder(),
      TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
    },
  ),
  iconTheme: IconThemeData(
    color: Color(0xFF999999),
  ),
);
