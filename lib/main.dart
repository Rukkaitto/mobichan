import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobichan/app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:mobichan/dependency_injector.dart' as dependency_injector;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  PaintingBinding.instance!.imageCache!.maximumSizeBytes = 1024 * 1024 * 300;
  await EasyLocalization.ensureInitialized();
  await dependency_injector.init();
  timeago.setLocaleMessages('fr', timeago.FrMessages());

  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('fr', 'FR'),
        Locale('nb', 'NO'),
      ],
      path: 'assets/translations',
      fallbackLocale: const Locale('en', 'US'),
      child: const App(),
    ),
  );
}
