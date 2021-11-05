library post_repository;

import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:post_repository/post_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Thrown if an exception occurs while making an `http` request.
class NetworkException implements Exception {}

/// Thrown if an excepton occurs while decoding the response body.
class JsonDecodeException implements Exception {}

class PostRepository {
  final String apiUrl = 'https://a.4cdn.org';
  final String threadHistoryKey = 'thread_history';

  Future<List<PostModel>> getPosts({
    required String board,
    required int thread,
  }) async {
    final response =
        await http.get(Uri.parse('$apiUrl/$board/thread/$thread.json'));

    if (response.statusCode == 200) {
      try {
        List<PostModel> posts = (jsonDecode(response.body)['posts'] as List)
            .map((model) => PostModel.fromJson(model))
            .toList();
        return posts;
      } on Exception {
        throw JsonDecodeException();
      }
    } else {
      throw NetworkException();
    }
  }

  Future<List<PostModel>> getThreads({
    required String board,
    Sort? sorting,
  }) async {
    final response = await http.get(Uri.parse('$apiUrl/$board/catalog.json'));

    if (response.statusCode == 200) {
      try {
        List<PostModel> threads = List.empty(growable: true);
        List pages = jsonDecode(response.body);

        for (var page in pages) {
          List opsInPage = page['threads'];
          for (var opInPage in opsInPage) {
            threads.add(PostModel.fromJson(opInPage));
          }
        }

        List<PostModel> sortedThreads = _sortThreads(threads, sorting);

        return sortedThreads;
      } on Exception {
        throw JsonDecodeException();
      }
    } else {
      throw NetworkException();
    }
  }

  Future<Response<String>> postThread({
    required String board,
    required String captchaChallenge,
    required String captchaResponse,
    required String com,
    String? name,
    String? subject,
    String? filePath,
  }) async {
    String url = "https://sys.4channel.org/$board/post";
    var dio = Dio();

    FormData formData = FormData.fromMap({
      "name": name ?? '',
      "sub": subject ?? '',
      "pwd": '',
      "email": '',
      "com": com,
      "mode": 'regist',
      "t-challenge": captchaChallenge,
      "t-response": captchaResponse,
    });

    if (filePath != null) {
      File file = File(filePath);
      formData.files.add(
        MapEntry(
          "upfile",
          await MultipartFile.fromFile(
            file.path,
            filename: file.path.split(Platform.pathSeparator).last,
          ),
        ),
      );
    }

    Map<String, String> headers = {
      "origin": "https://board.4channel.org",
      "referer": "https://board.4channel.org/",
    };

    try {
      return dio.post(
        url,
        data: formData,
        options: Options(
          headers: headers,
        ),
      );
    } on Exception {
      throw NetworkException();
    }
  }

  Future<Response<String>> postReply({
    required String board,
    required String captchaChallenge,
    required String captchaResponse,
    required int resto,
    String? name,
    String? com,
    String? filePath,
  }) async {
    String url = "https://sys.4channel.org/$board/post";
    var dio = Dio();

    FormData formData = FormData.fromMap({
      "name": name ?? '',
      "com": com ?? '',
      "mode": 'regist',
      "resto": resto.toString(),
      "t-challenge": captchaChallenge,
      "t-response": captchaResponse,
    });

    if (filePath != null) {
      File file = File(filePath);
      formData.files.add(
        MapEntry(
          "upfile",
          await MultipartFile.fromFile(
            file.path,
            filename: file.path.split(Platform.pathSeparator).last,
          ),
        ),
      );
    }

    Map<String, String> headers = {
      "origin": "https://board.4channel.org",
      "referer": "https://board.4channel.org/",
    };

    try {
      return dio.post(
        url,
        data: formData,
        options: Options(
          headers: headers,
        ),
      );
    } on Exception {
      throw NetworkException();
    }
  }

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

  List<PostModel> _sortThreads(List<PostModel> threads, Sort? sorting) {
    if (sorting != null) {
      switch (sorting) {
        case Sort.byBumpOrder:
          return threads
            ..sort((a, b) {
              return a.lastModified!.compareTo(b.lastModified!);
            });
        case Sort.byReplyCount:
          return threads
            ..sort((a, b) {
              return b.replies!.compareTo(a.replies!);
            });
        case Sort.byImagesCount:
          return threads
            ..sort((a, b) {
              return b.images!.compareTo(a.images!);
            });
        case Sort.byNewest:
          return threads
            ..sort((a, b) {
              return b.time.compareTo(a.time);
            });
        case Sort.byOldest:
          return threads
            ..sort((a, b) {
              return a.time.compareTo(b.time);
            });
      }
    } else {
      return threads;
    }
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
