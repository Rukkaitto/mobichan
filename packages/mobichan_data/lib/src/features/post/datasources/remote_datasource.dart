import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;

import 'package:mobichan_domain/mobichan_domain.dart';
import '../models/models.dart';
import '../../../core/exceptions/exceptions.dart';

abstract class PostRemoteDatasource {
  Future<List<PostModel>> getPosts(
      {required String board, required int thread});

  Future<List<PostModel>> getThreads({required String board, Sort? sorting});

  Future<String> postThread({
    required String board,
    required String captchaChallenge,
    required String captchaResponse,
    required String com,
    String? name,
    String? subject,
    String? filePath,
  });

  Future<String> postReply({
    required String board,
    required String captchaChallenge,
    required String captchaResponse,
    required int resto,
    String? name,
    String? com,
    String? filePath,
  });
}

class PostRemoteDatasourceImpl implements PostRemoteDatasource {
  final String apiUrl = 'https://a.4cdn.org';
  final String threadHistoryKey = 'thread_history';

  @override
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

  @override
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

  @override
  Future<String> postThread({
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
      Response<String> response = await dio.post(
        url,
        data: formData,
        options: Options(
          headers: headers,
        ),
      );
      return response.data!;
    } on Exception {
      throw NetworkException();
    }
  }

  @override
  Future<String> postReply({
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
      Response<String> response = await dio.post(
        url,
        data: formData,
        options: Options(
          headers: headers,
        ),
      );
      return response.data!;
    } on Exception {
      throw NetworkException();
    }
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
}
