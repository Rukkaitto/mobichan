import 'package:board_repository/board_repository.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobichan/constants.dart';
import 'package:mobichan/home.dart';
import 'package:mobichan/pages/boards/view/boards_view.dart';
import 'package:mobichan/pages/history_page.dart';
import 'package:mobichan/pages/settings_page.dart';

class App extends StatelessWidget {
  const App({
    Key? key,
    required BoardRepository boardRepository,
  })  : _boardRepository = boardRepository,
        super(key: key);

  final BoardRepository _boardRepository;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<BoardRepository>(
          create: (context) => _boardRepository,
        ),
      ],
      child: MaterialApp(
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          title: APP_TITLE,
          initialRoute: Home.routeName,
          routes: {
            Home.routeName: (context) => Home(),
            SettingsPage.routeName: (context) => SettingsPage(),
            HistoryPage.routeName: (context) => HistoryPage(),
            BoardsView.routeName: (context) => BoardsView(),
          },
          theme: ThemeData.dark().copyWith(
            pageTransitionsTheme: PageTransitionsTheme(builders: {
              TargetPlatform.android: CupertinoPageTransitionsBuilder(),
              TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
            }),
            colorScheme: ColorScheme.dark(primary: Colors.tealAccent),
          )),
    );
  }
}
