import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobichan/app.dart';
import 'package:mobichan/core/core.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:mobichan/dependency_injector.dart' as dependency_injector;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await dependency_injector.init();
  timeago.setLocaleMessages('fr', timeago.FrMessages());
  Analytics.sendDevice(active: true);

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en', 'US'), Locale('fr', 'FR')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en', 'US'),
      child: const App(),
    ),
  );
}
