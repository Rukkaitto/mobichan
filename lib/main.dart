import 'package:flutter/material.dart';
import 'package:mobichan/classes/arguments/board_page_arguments.dart';
import 'package:mobichan/classes/shared_preferences/board_shared_prefs.dart';
import 'package:mobichan/pages/board_page.dart';
import 'package:mobichan/pages/boards_list_page.dart';
import 'package:mobichan/utils/utils.dart';

import 'constants.dart';

void main() {
  runApp(App());
}

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: APP_TITLE,
      initialRoute: '/',
      routes: {
        BoardsListPage.routeName: (context) => BoardsListPage(),
      },
      home: BoardPage(
        args: BoardPageArguments(
          board: 'a',
          title: 'Anime & Manga',
        ),
      ),
    );
  }
}
