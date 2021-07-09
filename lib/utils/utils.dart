import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:mobichan/classes/models/board.dart';
import 'package:mobichan/classes/models/post.dart';
import 'package:mobichan/classes/shared_preferences/board_shared_prefs.dart';
import 'package:mobichan/constants.dart';
import 'package:mobichan/enums/enums.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

class Utils {
  static getLastVisitedBoard() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String lastVisitedBoard = prefs.getString(LAST_VISITED_BOARD) ?? '';
    String lastVisitedBoardTitle =
        prefs.getString(LAST_VISITED_BOARD_TITLE) ?? '';

    BoardSharedPrefs boardSharedPrefs =
        BoardSharedPrefs(board: lastVisitedBoard, title: lastVisitedBoardTitle);

    return boardSharedPrefs;
  }

  static saveLastVisitedBoard(
      {required String board, required String title}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(LAST_VISITED_BOARD, board);
    await prefs.setString(LAST_VISITED_BOARD_TITLE, title);
  }

  static saveLastSortingOrder(Sort sorting) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(LAST_SORTING_ORDER, jsonEncode(sorting.toString()));
  }

  static Future<Sort> getLastSortingOrder() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? lastSortingOrderString = prefs.getString(LAST_SORTING_ORDER);
    Sort lastSortingOrder = Utils.getSortFromString(
            jsonDecode(lastSortingOrderString ?? '') ?? '') ??
        Sort.byBumpOrder;
    return lastSortingOrder;
  }

  static bool isLocalFilePath(String path) {
    Uri uri = Uri.parse(path);
    return !uri.scheme.contains('http');
  }

  static Future<bool?> saveImage(String path, {String? albumName}) async {
    MethodChannel channel = const MethodChannel('gallery_saver');
    File? tempFile;
    if (!isLocalFilePath(path)) {
      tempFile = await _downloadFile(path);
      path = tempFile.path;
    }

    bool? result = await channel.invokeMethod(
      'saveImage',
      <String, dynamic>{'path': path, 'albumName': albumName},
    );
    if (tempFile != null) {
      tempFile.delete();
    }

    return result;
  }

  static Future<File> _downloadFile(String url) async {
    print(url);
    http.Client _client = new http.Client();
    var req = await _client.get(Uri.parse(url));
    var bytes = req.bodyBytes;
    String dir = (await getTemporaryDirectory()).path;
    File file = new File('$dir/${basename(url)}');
    await file.writeAsBytes(bytes);
    print('File size:${await file.length()}');
    print(file.path);
    return file;
  }

  static Future<bool> isThreadInHistory(Post thread) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> history;
    if (prefs.containsKey(THREAD_HISTORY)) {
      history = prefs.getStringList(THREAD_HISTORY)!;
    } else {
      history = List.empty(growable: true);
    }
    return history.map((e) {
      Post pastThread = Post.fromJson(jsonDecode(e));
      return pastThread.no;
    }).contains(thread.no);
  }

  static void addThreadToHistory(Post thread, String board) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> threadJson = thread.toJson();
    threadJson['board'] = board;
    String newThread = jsonEncode(threadJson);

    List<String> history;
    if (prefs.containsKey(THREAD_HISTORY)) {
      history = prefs.getStringList(THREAD_HISTORY)!;
    } else {
      history = List.empty(growable: true);
    }
    if (await isThreadInHistory(thread)) {
      history.remove(newThread);
    }
    history.add(newThread);
    prefs.setStringList(THREAD_HISTORY, history);
  }

  static List<Post> getReplies(List<Post> posts, Post post) {
    List<Post> replies = List.empty(growable: true);
    posts.forEach((otherPost) {
      final regExp = RegExp(r'(?<=href="#p)\d+(?=")');
      final matches = regExp
          .allMatches(otherPost.com ?? '')
          .map((match) => int.parse(match.group(0) ?? ""));

      // if another post quotes this post
      if (matches.contains(post.no)) {
        // add other post to replies list
        replies.add(otherPost);
      }
    });
    return replies;
  }

  static Post getQuotedPost(List<Post> posts, int no) {
    return posts.firstWhere((post) => post.no == no);
  }

  static Sort? getSortFromString(String sortAsString) {
    for (Sort element in Sort.values) {
      if (element.toString() == sortAsString) {
        return element;
      }
    }
    return null;
  }

  static Future<bool> isBoardInFavorites(Board board) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> favorites;
    if (prefs.containsKey(BOARD_FAVORITES)) {
      favorites = prefs.getStringList(BOARD_FAVORITES)!;
    } else {
      favorites = List.empty(growable: true);
    }
    final favoriteBoards = favorites.map((e) {
      Board pastBoard = Board.fromJson(jsonDecode(e));
      return pastBoard.board;
    });

    return favoriteBoards.toList().contains(board.board);
  }

  static void addBoardToFavorites(Board board) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> boardJson = board.toJson();
    String newBoard = jsonEncode(boardJson);

    List<String> favorites;
    if (prefs.containsKey(BOARD_FAVORITES)) {
      favorites = prefs.getStringList(BOARD_FAVORITES)!;
    } else {
      favorites = List.empty(growable: true);
    }
    if (await isBoardInFavorites(board)) {
      favorites.remove(newBoard);
    }
    favorites.add(newBoard);
    prefs.setStringList(BOARD_FAVORITES, favorites);
  }

  static void removeBoardFromFavorites(Board board) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> boardJson = board.toJson();
    String boardToRemove = jsonEncode(boardJson);

    List<String> favorites;
    if (prefs.containsKey(BOARD_FAVORITES)) {
      favorites = prefs.getStringList(BOARD_FAVORITES)!;
    } else {
      favorites = List.empty(growable: true);
    }
    if (await isBoardInFavorites(board)) {
      favorites.remove(boardToRemove);
    }
    prefs.setStringList(BOARD_FAVORITES, favorites);
  }
}
