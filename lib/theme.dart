import 'package:flutter/material.dart';

final ThemeData theme = ThemeData(
  brightness: Brightness.dark,
  textTheme: const TextTheme(
    bodyMedium: TextStyle(
      color: Colors.white,
      fontSize: 15.0,
    ),
    displayLarge: TextStyle(
      color: Colors.white,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
    displayMedium: TextStyle(
      color: Colors.white,
      fontSize: 15,
      fontWeight: FontWeight.w600,
    ),
    titleMedium: TextStyle(
      color: Color(0xFF888888),
      fontWeight: FontWeight.w600,
    ),
    titleSmall: TextStyle(
      color: Color(0xFF888888),
    ),
    bodySmall: TextStyle(
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
