import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/models.dart';

abstract class BoardLocalDatasource {
  Future<List<BoardModel>> getFavoriteBoards();

  Future<bool> isBoardInFavorites(BoardModel board);

  Future<void> addBoardToFavorites(BoardModel board);

  Future<void> removeBoardFromFavorites(BoardModel board);
}

class BoardLocalDataSourceImpl implements BoardLocalDatasource {
  final String boardFavoritesKey = 'board_favorites';

  @override
  Future<void> addBoardToFavorites(BoardModel board) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> boardJson = board.toJson();
    String newBoard = jsonEncode(boardJson);

    List<String> favorites;
    if (prefs.containsKey(boardFavoritesKey)) {
      favorites = prefs.getStringList(boardFavoritesKey)!;
    } else {
      favorites = List.empty(growable: true);
    }
    if (await isBoardInFavorites(board)) {
      favorites.remove(newBoard);
    }
    favorites.add(newBoard);
    prefs.setStringList(boardFavoritesKey, favorites);
  }

  @override
  Future<List<BoardModel>> getFavoriteBoards() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<BoardModel> favorites = List.empty();
    if (prefs.containsKey(boardFavoritesKey)) {
      favorites = prefs
          .getStringList(boardFavoritesKey)!
          .map((board) => BoardModel.fromJson(jsonDecode(board)))
          .toList()
        ..sort((a, b) => a.board.compareTo(b.board));
    }
    return favorites;
  }

  @override
  Future<bool> isBoardInFavorites(BoardModel board) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> favorites;
    if (prefs.containsKey(boardFavoritesKey)) {
      favorites = prefs.getStringList(boardFavoritesKey)!;
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
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> boardJson = board.toJson();
    String boardToRemove = jsonEncode(boardJson);

    List<String> favorites;
    if (prefs.containsKey(boardFavoritesKey)) {
      favorites = prefs.getStringList(boardFavoritesKey)!;
    } else {
      favorites = List.empty(growable: true);
    }
    if (await isBoardInFavorites(board)) {
      favorites.remove(boardToRemove);
    }
    prefs.setStringList(boardFavoritesKey, favorites);
  }
}
