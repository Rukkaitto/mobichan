import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'package:mobichan/classes/arguments/board_page_arguments.dart';
import 'package:mobichan/constants.dart';
import 'package:mobichan/extensions/string_extension.dart';
import 'package:mobichan/pages/board_page.dart';
import 'package:mobichan/pages/nsfw_warning_page.dart';
import 'package:mobichan/utils/updater.dart';
import 'package:mobichan/widgets/update_widget/update_widget.dart';
import 'package:mobichan_domain/mobichan_domain.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  static String routeName = HOME_ROUTE;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _nsfwWarningDismissed = false;

  @override
  void initState() {
    if (Platform.isAndroid) {
      setOptimalDisplayMode();
    }
    super.initState();
    if (String.fromEnvironment(ENVIRONMENT, defaultValue: GITHUB) == GITHUB) {
      Updater.checkForUpdates(context).then((needsUpdate) {
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
        builder: (BuildContext context,
            AsyncSnapshot<SharedPreferences> prefsSnapshot) {
          if (prefsSnapshot.hasData) {
            SharedPreferences prefs = prefsSnapshot.data!;
            return FutureBuilder(
              future: context.read<BoardRepository>().getLastVisitedBoard(),
              builder:
                  (BuildContext context, AsyncSnapshot<Board> boardSnapshot) {
                if (boardSnapshot.hasData) {
                  Board lastVisitedBoard = boardSnapshot.data!;
                  bool showWarning = true;
                  if (prefs.containsKey("SHOW_NSFW_WARNING")) {
                    showWarning =
                        prefs.getString("SHOW_NSFW_WARNING")!.parseBool();
                  }
                  return showWarning &&
                          (lastVisitedBoard.wsBoard == 0 &&
                              !_nsfwWarningDismissed)
                      ? NsfwWarningPage(onDismiss: _dismissNsfwWarning)
                      : BoardPage(
                          args: BoardPageArguments(lastVisitedBoard),
                        );
                }
                if (boardSnapshot.hasError) {
                  return Center(
                    child: Text(
                      "${boardSnapshot.error}",
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
          } else {
            return Container();
          }
        });
  }
}
