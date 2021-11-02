import 'package:flutter/material.dart';
import 'package:mobichan/classes/arguments/board_page_arguments.dart';
import 'package:mobichan/classes/models/board.dart';
import 'package:mobichan/pages/board_page.dart';
import 'package:mobichan/utils/utils.dart';
import 'package:stacked/stacked.dart';

class BoardTileViewModel extends FutureViewModel<bool> {
  bool _isFavorite = false;
  late Board _board;

  BoardTileViewModel(this._board);

  get isFavorite => _isFavorite;
  get board => _board;

  @override
  void onData(bool? data) {
    _isFavorite = data!;
    super.onData(data);
  }

  @override
  Future<bool> futureToRun() => Utils.isBoardInFavorites(board);

  void onPressedFavorite(Board board) {
    isFavorite
        ? Utils.removeBoardFromFavorites(board)
        : Utils.addBoardToFavorites(board);
    _isFavorite = !isFavorite;
    notifyListeners();
  }

  void goToBoard(BuildContext context, Board board) {
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
  }
}
