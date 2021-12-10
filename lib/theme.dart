import 'package:flutter/material.dart';

final ThemeData theme = ThemeData(
  brightness: Brightness.dark,
  textTheme: const TextTheme(
    bodyText2: TextStyle(
      color: Colors.white,
      fontSize: 15.0,
    ),
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
    caption: TextStyle(
      color: Color(0xFF646464),
    ),
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF202020),
    elevation: 0,
  ),
  scaffoldBackgroundColor: const Color(0xFF202020),
  cardColor: const Color(0xFF2E2E2E),
  canvasColor: const Color(0xFF202020),
  pageTransitionsTheme: const PageTransitionsTheme(
    builders: {
      TargetPlatform.android: CupertinoPageTransitionsBuilder(),
      TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
    },
  ),
  iconTheme: const IconThemeData(
    color: Color(0xFF999999),
  ),
);
