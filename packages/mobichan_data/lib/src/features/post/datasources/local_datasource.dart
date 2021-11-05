import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/models.dart';

abstract class PostLocalDatasource {
  Future<void> addThreadToHistory(PostModel thread, String board);
}

class PostLocalDatasourceImpl implements PostLocalDatasource {
  final String apiUrl = 'https://a.4cdn.org';
  final String threadHistoryKey = 'thread_history';

  @override
  Future<void> addThreadToHistory(PostModel thread, String board) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> threadJson = thread.toJson();
    threadJson['board'] = board;
    String newThread = jsonEncode(threadJson);

    List<String> history;
    if (prefs.containsKey(threadHistoryKey)) {
      history = prefs.getStringList(threadHistoryKey)!;
    } else {
      history = List.empty(growable: true);
    }
    if (await _isThreadInHistory(thread)) {
      history.remove(newThread);
    }
    history.add(newThread);
    prefs.setStringList(threadHistoryKey, history);
  }

  Future<bool> _isThreadInHistory(PostModel thread) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> history;
    if (prefs.containsKey(threadHistoryKey)) {
      history = prefs.getStringList(threadHistoryKey)!;
    } else {
      history = List.empty(growable: true);
    }
    return history.map((e) {
      PostModel pastThread = PostModel.fromJson(jsonDecode(e));
      return pastThread.no;
    }).contains(thread.no);
  }
}