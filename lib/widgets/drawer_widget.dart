import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobichan/classes/arguments/board_page_arguments.dart';
import 'package:mobichan/classes/models/board.dart';
import 'package:mobichan/constants.dart';
import 'package:mobichan/pages/board_page.dart';
import 'package:mobichan/pages/boards_list_page.dart';
import 'package:mobichan/pages/history_page.dart';
import 'package:mobichan/pages/settings_page.dart';
import 'package:mobichan/utils/utils.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DrawerWidget extends StatefulWidget {
  @override
  _DrawerWidgetState createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Column(
              children: [
                ListTile(
                  leading: Icon(Icons.list_rounded),
                  title: Text("Boards"),
                  onTap: () =>
                      Navigator.pushNamed(context, BoardsListPage.routeName)
                          .then((_) => setState(() {})),
                ),
                ListTile(
                  leading: Icon(Icons.history_rounded),
                  title: Text("History"),
                  onTap: () =>
                      Navigator.pushNamed(context, HistoryPage.routeName),
                ),
                ListTile(
                  leading: Icon(Icons.settings_rounded),
                  title: Text("Settings"),
                  onTap: () =>
                      Navigator.pushNamed(context, SettingsPage.routeName),
                ),
              ],
            ),
            DrawerFavorites(scrollController: _scrollController),
            Padding(
              padding: const EdgeInsets.all(10),
              child: FutureBuilder(
                future: PackageInfo.fromPlatform(),
                builder: (BuildContext context,
                    AsyncSnapshot<PackageInfo> snapshot) {
                  if (snapshot.hasData) {
                    return Text(
                      'v${snapshot.data!.version}+${snapshot.data!.buildNumber}',
                      style: Theme.of(context).textTheme.caption,
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DrawerFavorites extends StatelessWidget {
  const DrawerFavorites({
    Key? key,
    required ScrollController scrollController,
  })  : _scrollController = scrollController,
        super(key: key);

  final ScrollController _scrollController;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: FutureBuilder(
        future: SharedPreferences.getInstance(),
        builder: (context, AsyncSnapshot<SharedPreferences> snapshot) {
          if (snapshot.hasData) {
            SharedPreferences prefs = snapshot.data!;
            List<Board> favorites = List.empty();
            if (prefs.containsKey(BOARD_FAVORITES)) {
              favorites = prefs
                  .getStringList(BOARD_FAVORITES)!
                  .map((board) => Board.fromJson(jsonDecode(board)))
                  .toList()
                    ..sort((a, b) => a.board.compareTo(b.board));
            }
            return Scrollbar(
              controller: _scrollController,
              isAlwaysShown: true,
              child: ListView.separated(
                separatorBuilder: (context, index) => Divider(
                  color: Colors.grey,
                ),
                controller: _scrollController,
                physics: AlwaysScrollableScrollPhysics(),
                itemCount: favorites.length,
                itemBuilder: (context, index) {
                  Board board = favorites[index];
                  return ListTile(
                    title: Text(
                      '/${board.board}/ - ${board.title}',
                    ),
                    onTap: () {
                      Utils.saveLastVisitedBoard(
                          board: board.board, title: board.title);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BoardPage(
                            args: BoardPageArguments(
                              board: board.board,
                              title: board.title,
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
