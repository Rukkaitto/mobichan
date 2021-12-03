import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobichan/dependency_injector.dart';
import 'package:mobichan/theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mobichan/constants.dart';
import 'package:mobichan/home.dart';
import 'package:mobichan_domain/mobichan_domain.dart';

import 'features/setting/setting.dart';
import 'features/post/post.dart';

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return RepositoryProvider<ReleaseRepository>(
            create: (context) => sl(),
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
                GalleryPage.routeName: (context) => const GalleryPage(),
              },
              theme: theme.copyWith(
                colorScheme: theme.colorScheme.copyWith(
                  secondary: const Color(0xFF6DEFDF),
                  secondaryVariant: const Color(0xFF54BDB0),
                ),
              ),
            ),
          );
        }
        return Container();
      },
    );
  }
}
