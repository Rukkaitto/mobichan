import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:mobichan_domain/mobichan_domain.dart';
import 'package:mobichan_data/mobichan_data.dart';

abstract class BoardLocalDatasource {
  Future<List<BoardModel>> getFavoriteBoards();

  Future<bool> isBoardInFavorites(BoardModel board);

  Future<void> addBoardToFavorites(BoardModel board);

  Future<void> removeBoardFromFavorites(BoardModel board);

  Future<BoardModel> getLastVisitedBoard();

  Future<void> saveLastVisitedBoard(BoardModel board);
}

class BoardLocalDatasourceImpl implements BoardLocalDatasource {
  final String boardFavoritesKey = 'board_favorites';
  final String lastVisitedBoardKey = 'last_visited_board';

  final SharedPreferences sharedPreferences;

  BoardLocalDatasourceImpl({required this.sharedPreferences});

  @override
  Future<void> addBoardToFavorites(BoardModel board) async {
    Map<String, dynamic> boardJson = board.toJson();
    String newBoard = jsonEncode(boardJson);

    List<String> favorites;
    if (sharedPreferences.containsKey(boardFavoritesKey)) {
      favorites = sharedPreferences.getStringList(boardFavoritesKey)!;
    } else {
      favorites = List.empty(growable: true);
    }
    if (!await isBoardInFavorites(board)) {
      favorites.add(newBoard);
    }
    sharedPreferences.setStringList(boardFavoritesKey, favorites);
  }

  @override
  Future<List<BoardModel>> getFavoriteBoards() async {
    List<BoardModel> favorites = List.empty();
    if (sharedPreferences.containsKey(boardFavoritesKey)) {
      favorites = sharedPreferences
          .getStringList(boardFavoritesKey)!
          .map((board) => BoardModel.fromJson(jsonDecode(board)))
          .toList()
        ..sort((a, b) => a.board.compareTo(b.board));
    }
    return favorites;
  }

  @override
  Future<bool> isBoardInFavorites(BoardModel board) async {
    List<String> favorites;
    if (sharedPreferences.containsKey(boardFavoritesKey)) {
      favorites = sharedPreferences.getStringList(boardFavoritesKey)!;
    } else {
      favorites = List.empty(growable: true);
    }
    final favoriteBoards = favorites.map((e) {
      BoardModel pastBoard = BoardModel.fromJson(jsonDecode(e));
      return pastBoard.board;
    });

    return favoriteBoards.toList().contains(board.board);
  }

  @override
  Future<void> removeBoardFromFavorites(BoardModel board) async {
    Map<String, dynamic> boardJson = board.toJson();
    String boardToRemove = jsonEncode(boardJson);

    List<String> favorites;
    if (sharedPreferences.containsKey(boardFavoritesKey)) {
      favorites = sharedPreferences.getStringList(boardFavoritesKey)!;
    } else {
      favorites = List.empty(growable: true);
    }
    if (await isBoardInFavorites(board)) {
      favorites.remove(boardToRemove);
    }
    sharedPreferences.setStringList(boardFavoritesKey, favorites);
  }

  @override
  Future<BoardModel> getLastVisitedBoard() async {
    String? lastVisitedBoardEncoded =
        sharedPreferences.getString(lastVisitedBoardKey);
    if (lastVisitedBoardEncoded != null) {
      return BoardModel.fromJson(jsonDecode(lastVisitedBoardEncoded));
    } else {
      return BoardModel.fromEntity(Board.initial);
    }
  }

  @override
  Future<void> saveLastVisitedBoard(BoardModel board) async {
    await sharedPreferences.setString(
        lastVisitedBoardKey, jsonEncode(board.toJson()));
  }
}
