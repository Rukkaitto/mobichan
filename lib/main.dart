import 'package:flutter/material.dart';
import 'package:mobichan/classes/arguments/board_page_arguments.dart';
import 'package:mobichan/pages/board_page.dart';
import 'package:mobichan/pages/boards_list_page.dart';
import 'package:mobichan/pages/settings_page.dart';
import 'package:mobichan/utils/updater.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    Updater.checkForUpdates();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: APP_TITLE,
      initialRoute: '/',
      debugShowCheckedModeBanner: false,
      routes: {
        BoardsListPage.routeName: (context) => BoardsListPage(),
        SettingsPage.routeName: (context) => SettingsPage(),
      },
      theme: ThemeData.dark().copyWith(
        colorScheme: ColorScheme.dark(primary: Colors.tealAccent),
      ),
      home: _buildHome(),
    );
  }

  FutureBuilder<SharedPreferences> _buildHome() {
    return FutureBuilder(
      future: SharedPreferences.getInstance(),
      builder:
          (BuildContext context, AsyncSnapshot<SharedPreferences> snapshot) {
        if (snapshot.hasData) {
          return BoardPage(
            args: BoardPageArguments(
              board: snapshot.data!.containsKey(LAST_VISITED_BOARD)
                  ? snapshot.data!.getString(LAST_VISITED_BOARD)!
                  : DEFAULT_BOARD,
              title: snapshot.data!.containsKey(LAST_VISITED_BOARD_TITLE)
                  ? snapshot.data!.getString(LAST_VISITED_BOARD_TITLE)!
                  : DEFAULT_BOARD_TITLE,
            ),
          );
        }
        if (snapshot.hasError) {
          return Center(
            child: Text(
              "${snapshot.error}",
              style: TextStyle(
                color: Theme.of(context).errorColor,
              ),
            ),
          );
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
