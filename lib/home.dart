import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'package:mobichan/constants.dart';
import 'package:mobichan/core/core.dart';
import 'package:mobichan/features/board/board.dart';
import 'package:mobichan/features/post/post.dart';
import 'package:mobichan_domain/mobichan_domain.dart';

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
    _setupInteractedMessage();
    setOptimalDisplayMode();
    checkForUpdates();
  }

  @override
  Widget build(BuildContext context) {
    return const BoardNsfwCheckPage();
  }

  void _handleMessage(RemoteMessage message) {
    final data = message.data;
    final String board = data['board_id'];
    final String title = data['board_title'];
    final wsBoard = int.parse(data['board_ws']);
    final thread = int.parse(data['thread']);
    print(data);

    Navigator.pushNamed(
      context,
      ThreadPage.routeName,
      arguments: ThreadPageArguments(
        board: Board(board: board, title: title, wsBoard: wsBoard),
        thread: Post(no: thread),
      ),
    );
  }

  Future<void> _setupInteractedMessage() async {
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }

    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
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

  void checkForUpdates() {
    if (const String.fromEnvironment(environment) == github &&
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
