import 'package:mobichan/dependency_injector.dart';
import 'package:mobichan/theme.dart';
import 'package:mobichan_domain/mobichan_domain.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobichan/constants.dart';
import 'package:mobichan/home.dart';

import 'features/setting/setting.dart';
import 'features/post/post.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<ReleaseRepository>(
      create: (context) => sl<ReleaseRepository>(),
      child: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
        child: MaterialApp(
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          title: appTitle,
          initialRoute: Home.routeName,
          routes: {
            Home.routeName: (context) => const Home(),
            ThreadPage.routeName: (context) => ThreadPage(),
            SettingsPage.routeName: (context) => const SettingsPage(),
          },
          theme: theme.copyWith(
            colorScheme: theme.colorScheme.copyWith(
              primary: const Color(0xFF61D3C3),
              secondary: const Color(0xFF61D3C3),
            ),
          ),
        ),
      ),
    );
  }
}
