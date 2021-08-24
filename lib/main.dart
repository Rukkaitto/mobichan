import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'package:mobichan/classes/arguments/board_page_arguments.dart';
import 'package:mobichan/extensions/string_extension.dart';
import 'package:mobichan/pages/board_page.dart';
import 'package:mobichan/pages/boards_list_page.dart';
import 'package:mobichan/pages/history_page.dart';
import 'package:mobichan/pages/nsfw_warning_page.dart';
import 'package:mobichan/pages/settings_page.dart';
import 'package:mobichan/utils/updater.dart';
import 'package:mobichan/widgets/update_widget/update_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'constants.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      title: APP_TITLE,
      initialRoute: '/',
      routes: {
        BoardsListPage.routeName: (context) => BoardsListPage(),
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
      home: App(),
    ),
  );
}

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  bool _nsfwWarningDismissed = false;

  @override
  void initState() {
    if (Platform.isAndroid) {
      setOptimalDisplayMode();
    }
    super.initState();
    if (String.fromEnvironment(ENVIRONMENT, defaultValue: GITHUB) == GITHUB) {
      Updater.checkForUpdates().then((needsUpdate) {
        if (needsUpdate) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) => UpdateWidget(),
          );
        }
      });
    }
  }

  Future<void> setOptimalDisplayMode() async {
    final List<DisplayMode> supported = await FlutterDisplayMode.supported;
    final DisplayMode active = await FlutterDisplayMode.active;

    final List<DisplayMode> sameResolution = supported
        .where((DisplayMode m) =>
            m.width == active.width && m.height == active.height)
        .toList()
          ..sort((DisplayMode a, DisplayMode b) =>
              b.refreshRate.compareTo(a.refreshRate));

    final DisplayMode mostOptimalMode =
        sameResolution.isNotEmpty ? sameResolution.first : active;

    /// This setting is per session.
    /// Please ensure this was placed with `initState` of your root widget.
    await FlutterDisplayMode.setPreferredMode(mostOptimalMode);
  }

  void _dismissNsfwWarning() {
    setState(() {
      _nsfwWarningDismissed = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: SharedPreferences.getInstance(),
      builder:
          (BuildContext context, AsyncSnapshot<SharedPreferences> snapshot) {
        if (snapshot.hasData) {
          final prefs = snapshot.data!;
          int wsBoard = 1;
          if (prefs.containsKey(LAST_VISITED_BOARD_WS)) {
            wsBoard = prefs.getInt(LAST_VISITED_BOARD_WS)!;
          }
          bool showWarning = true;
          if (prefs.containsKey("SHOW_NSFW_WARNING")) {
            showWarning = prefs.getString("SHOW_NSFW_WARNING")!.parseBool();
          }
          return showWarning && (wsBoard == 0 && !_nsfwWarningDismissed)
              ? NsfwWarningPage(onDismiss: _dismissNsfwWarning)
              : BoardPage(
                  args: BoardPageArguments(
                    board: prefs.containsKey(LAST_VISITED_BOARD)
                        ? prefs.getString(LAST_VISITED_BOARD)!
                        : DEFAULT_BOARD,
                    title: prefs.containsKey(LAST_VISITED_BOARD_TITLE)
                        ? prefs.getString(LAST_VISITED_BOARD_TITLE)!
                        : DEFAULT_BOARD_TITLE,
                    wsBoard: prefs.containsKey(LAST_VISITED_BOARD_WS)
                        ? prefs.getInt(LAST_VISITED_BOARD_WS)!
                        : DEFAULT_BOARD_WS,
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
