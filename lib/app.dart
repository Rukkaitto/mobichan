// ignore: implementation_imports
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:mobichan/constants.dart';
import 'package:mobichan/home.dart';
import 'package:mobichan/pages/history_page.dart';
import 'package:mobichan/pages/settings_page.dart';
import 'package:stacked_services/stacked_services.dart';

class App extends StatelessWidget {
  const App({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      title: APP_TITLE,
      navigatorKey: StackedService.navigatorKey,
      initialRoute: '/',
      routes: {
        Home.routeName: (context) => Home(),
        SettingsPage.routeName: (context) => SettingsPage(),
        HistoryPage.routeName: (context) => HistoryPage(),
      },
      theme: ThemeData.dark().copyWith(
        pageTransitionsTheme: PageTransitionsTheme(builders: {
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        }),
        colorScheme: ColorScheme.dark(primary: Colors.tealAccent),
      ),
    );
  }
}
