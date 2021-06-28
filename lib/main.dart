import 'package:flutter/material.dart';
import 'package:mobichan/classes/arguments/board_page_arguments.dart';
import 'package:mobichan/pages/board_page.dart';
import 'package:mobichan/pages/boards_list_page.dart';

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
      darkTheme: ThemeData.dark(),
      home: BoardPage(
        args: BoardPageArguments(
          board: 'g',
          title: 'Technology',
        ),
      ),
    );
  }
}
