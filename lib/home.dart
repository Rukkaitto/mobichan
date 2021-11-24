import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'package:mobichan/constants.dart';
import 'package:mobichan/features/board/board.dart';
import 'package:mobichan/utils/updater.dart';

import 'features/release/release.dart';

class Home extends StatelessWidget {
  static String routeName = '/';

  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    setOptimalDisplayMode();
    checkForUpdates(context);

    return const BoardNsfwCheckPage();
  }

  Future<void> setOptimalDisplayMode() async {
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

  void checkForUpdates(BuildContext context) {
    if (const String.fromEnvironment(environement, defaultValue: github) ==
            github &&
        Platform.isAndroid) {
      Updater.checkForUpdates(context).then((needsUpdate) {
        if (needsUpdate) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) => const UpdateWidget(),
          );
        }
      });
    }
  }
}
