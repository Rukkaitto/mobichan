import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobichan/classes/arguments/board_page_arguments.dart';
import 'package:mobichan/classes/models/board.dart';
import 'package:mobichan/pages/board_page.dart';
import 'package:mobichan/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../constants.dart';

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
                        board: board.board,
                        title: board.title,
                        wsBoard: board.wsBoard,
                      );
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BoardPage(
                            args: BoardPageArguments(
                              board: board.board,
                              title: board.title,
                              wsBoard: board.wsBoard,
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
