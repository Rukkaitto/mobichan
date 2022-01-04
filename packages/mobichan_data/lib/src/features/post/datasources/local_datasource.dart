import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:mobichan_data/mobichan_data.dart';
import 'package:sqflite/sqflite.dart';

abstract class PostLocalDatasource {
  Future<List<PostModel>> addThreadToHistory(
      PostModel thread, BoardModel board);

  Future<List<PostModel>> getHistory();

  Future<void> insertPost(BoardModel board, PostModel post);

  Future<void> insertPosts(BoardModel board, List<PostModel> posts);

  Future<List<PostModel>> getCachedPosts(PostModel thread);

  Future<List<PostModel>> getCachedThreads(
      {required BoardModel board, required SortModel sort});
}

class PostLocalDatasourceImpl implements PostLocalDatasource {
  final String apiUrl = 'https://a.4cdn.org';
  final String threadHistoryKey = 'thread_history';

  final SharedPreferences sharedPreferences;
  final Database database;

  PostLocalDatasourceImpl({
    required this.sharedPreferences,
    required this.database,
  });

  @override
  Future<List<PostModel>> addThreadToHistory(
      PostModel thread, BoardModel board) async {
    Map<String, dynamic> threadJson = thread.toJson();
    threadJson['board_id'] = board.board;
    threadJson['board_title'] = board.title;
    threadJson['board_ws'] = board.wsBoard;
    PostModel newThread = PostModel.fromJson(threadJson);

    // Gets the history strings from the shared preferences
    List<String> historyStrings;
    if (sharedPreferences.containsKey(threadHistoryKey)) {
      historyStrings = sharedPreferences.getStringList(threadHistoryKey)!;
    } else {
      historyStrings = List.empty(growable: true);
    }

    // Converts the history string list to a list of PostModel
    List<PostModel> history = List.generate(historyStrings.length, (index) {
      return PostModel.fromJson(jsonDecode(historyStrings[index]));
    });

    if (history.contains(newThread)) {
      history.remove(newThread);
    }
    history.add(newThread);

    // Converts the history back into a list of strings
    List<String> historyStringsNew = List.generate(history.length, (index) {
      return jsonEncode(history[index].toJson());
    });

    sharedPreferences.setStringList(threadHistoryKey, historyStringsNew);
    return history;
  }

  @override
  Future<List<PostModel>> getHistory() async {
    if (sharedPreferences.containsKey(threadHistoryKey)) {
      List<String> historyStringList =
          sharedPreferences.getStringList(threadHistoryKey)!.reversed.toList();
      List<PostModel> history = historyStringList
          .map((e) => PostModel.fromJson(jsonDecode(e)))
          .toList();
      return history;
    }
    return [];
  }

  @override
  Future<void> insertPost(BoardModel board, PostModel post) async {
    final postJson = post.toJson();
    postJson['board_id'] = board.board;
    postJson['board_title'] = board.title;
    postJson['board_ws'] = board.wsBoard;

    await database.insert(
      'posts',
      postJson,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> insertPosts(BoardModel board, List<PostModel> posts) async {
    final batch = database.batch();
    for (PostModel post in posts) {
      final postJson = post.toJson();
      postJson['board_id'] = board.board;
      postJson['board_title'] = board.title;
      postJson['board_ws'] = board.wsBoard;

      batch.insert(
        'posts',
        postJson,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);
  }

  @override
  Future<List<PostModel>> getCachedPosts(PostModel thread) async {
    final maps = await database
        .query('posts', where: 'resto = ?', whereArgs: [thread.no]);
    return List.generate(maps.length, (index) {
      return PostModel.fromJson(maps[index]);
    });
  }

  @override
  Future<List<PostModel>> getCachedThreads({
    required BoardModel board,
    required SortModel sort,
  }) async {
    final maps = await database.query(
      'posts',
      where: 'resto = 0 AND board_id = ?',
      whereArgs: [board.board],
    );
    final threads = List.generate(maps.length, (index) {
      return PostModel.fromJson(maps[index]);
    });
    return threads.sortedBySort(sort);
  }
}
