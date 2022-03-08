import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'package:mobichan/constants.dart';
import 'package:mobichan/core/core.dart';
import 'package:mobichan/features/board/board.dart';

import 'features/release/release.dart';

class Home extends StatefulWidget {
  static String routeName = '/';

  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    _setOptimalDisplayMode();
    _checkForUpdates();
  }

  @override
  Widget build(BuildContext context) {
    return const BoardNsfwCheckPage();
  }

  Future<void> _setOptimalDisplayMode() async {
    if (Platform.isAndroid) {
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

      await FlutterDisplayMode.setPreferredMode(mostOptimalMode);
    }
  }

  void _checkForUpdates() {
    Updater.checkForUpdates(context).then((needsUpdate) {
      if (needsUpdate) {
        if (const String.fromEnvironment(environment) == github &&
            Platform.isAndroid) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) => const UpdateWidget(),
          );
        } else {
          if (Platform.isIOS) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) => const UpdateWidgetIos(),
            );
          }
        }
      }
    });
  }
}
