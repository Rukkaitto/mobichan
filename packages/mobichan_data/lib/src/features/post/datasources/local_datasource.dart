import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:mobichan_data/mobichan_data.dart';

abstract class PostLocalDatasource {
  Future<void> addThreadToHistory(PostModel thread, BoardModel board);

  Future<List<PostModel>> getHistory();
}

class PostLocalDatasourceImpl implements PostLocalDatasource {
  final String apiUrl = 'https://a.4cdn.org';
  final String threadHistoryKey = 'thread_history';

  final SharedPreferences sharedPreferences;

  PostLocalDatasourceImpl({required this.sharedPreferences});

  @override
  Future<void> addThreadToHistory(PostModel thread, BoardModel board) async {
    Map<String, dynamic> threadJson = thread.toJson();
    threadJson['board'] = jsonEncode(board.toJson());
    String newThread = jsonEncode(threadJson);

    List<String> history;
    if (sharedPreferences.containsKey(threadHistoryKey)) {
      history = sharedPreferences.getStringList(threadHistoryKey)!;
    } else {
      history = List.empty(growable: true);
    }
    if (await _isThreadInHistory(thread)) {
      history.remove(newThread);
    }
    history.add(newThread);
    sharedPreferences.setStringList(threadHistoryKey, history);
  }

  Future<bool> _isThreadInHistory(PostModel thread) async {
    List<String> history;
    if (sharedPreferences.containsKey(threadHistoryKey)) {
      history = sharedPreferences.getStringList(threadHistoryKey)!;
    } else {
      history = List.empty(growable: true);
    }
    return history.map((e) {
      PostModel pastThread = PostModel.fromJson(jsonDecode(e));
      return pastThread.no;
    }).contains(thread.no);
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
}
