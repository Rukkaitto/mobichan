import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:mobichan/classes/arguments/board_page_arguments.dart';
import 'package:mobichan/pages/board_page.dart';
import 'package:mobichan/pages/boards_list_page.dart';
import 'package:mobichan/pages/history_page.dart';
import 'package:mobichan/pages/settings_page.dart';
import 'package:mobichan/widgets/update_dialog_widget.dart';
import 'package:mobichan/utils/updater.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'constants.dart';

void main() {
  runApp(
    MaterialApp(
      title: APP_TITLE,
      initialRoute: '/',
      routes: {
        BoardsListPage.routeName: (context) => BoardsListPage(),
        SettingsPage.routeName: (context) => SettingsPage(),
        HistoryPage.routeName: (context) => HistoryPage(),
      },
      theme: ThemeData.dark().copyWith(
        colorScheme: ColorScheme.dark(primary: Colors.tealAccent),
      ),
      home: App(),
    ),
  );
}

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    super.initState();
    if (String.fromEnvironment(ENVIRONMENT, defaultValue: GITHUB) == GITHUB) {
      Updater.checkForUpdates().then((needsUpdate) {
        if (needsUpdate) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) => UpdateDialogWidget(),
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
