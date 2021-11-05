library board_repository;

import 'dart:convert';

import 'package:board_repository/board_repository.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

/// Thrown if an excepton occurs while decoding the response body.
class NetworkException implements Exception {}

class BoardRepository {
  final String boardsUrl = 'https://a.4cdn.org/boards.json';
  final String boardFavoritesKey = 'board_favorites';

  Future<List<Board>> getBoards() async {
    final response = await http.get(Uri.parse(boardsUrl));

    if (response.statusCode == 200) {
      List<Board> boards = (jsonDecode(response.body)['boards'] as List)
          .map((model) => Board.fromJson(model))
          .toList();
      return boards;
    } else {
      throw NetworkException();
    }
  }

  Future<List<Board>> getFavoriteBoards() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<Board> favorites = List.empty();
    if (prefs.containsKey(boardFavoritesKey)) {
      favorites = prefs
          .getStringList(boardFavoritesKey)!
          .map((board) => Board.fromJson(jsonDecode(board)))
          .toList()
        ..sort((a, b) => a.board.compareTo(b.board));
    }
    return favorites;
  }

  Future<bool> isBoardInFavorites(Board board) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> favorites;
    if (prefs.containsKey(boardFavoritesKey)) {
      favorites = prefs.getStringList(boardFavoritesKey)!;
    } else {
      favorites = List.empty(growable: true);
    }
    final favoriteBoards = favorites.map((e) {
      Board pastBoard = Board.fromJson(jsonDecode(e));
      return pastBoard.board;
    });

    return favoriteBoards.toList().contains(board.board);
  }

  Future<void> addBoardToFavorites(Board board) async {
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

  Future<void> removeBoardFromFavorites(Board board) async {
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
