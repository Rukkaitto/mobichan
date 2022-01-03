import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';

import 'package:mobichan_domain/mobichan_domain.dart';
import 'package:mobichan_data/mobichan_data.dart';

abstract class PostRemoteDatasource {
  Future<List<PostModel>> getPosts({
    required BoardModel board,
    required PostModel thread,
  });

  Future<List<PostModel>> getThreads(
      {required BoardModel board, required Sort sort});

  Future<void> postThread({
    required BoardModel board,
    required String captchaChallenge,
    required String captchaResponse,
    required PostModel post,
    String? filePath,
  });

  Future<void> postReply({
    required BoardModel board,
    required String captchaChallenge,
    required String captchaResponse,
    required PostModel resto,
    required PostModel post,
    String? filePath,
  });
}

class PostRemoteDatasourceImpl implements PostRemoteDatasource {
  final String apiUrl = 'https://a.4cdn.org';
  final String threadHistoryKey = 'thread_history';

  final Dio client;
  final NetworkInfo networkInfo;

  PostRemoteDatasourceImpl({required this.client, required this.networkInfo});

  @override
  Future<List<PostModel>> getPosts({
    required BoardModel board,
    required PostModel thread,
  }) async {
    if (await networkInfo.isConnected) {
      final response = await client
          .get<String>('$apiUrl/${board.board}/thread/${thread.no}.json');

      if (response.statusCode == 200) {
        try {
          List<PostModel> posts = (jsonDecode(response.data!)['posts'] as List)
              .map((model) => PostModel.fromJson(model))
              .toList();
          return posts;
        } on Exception {
          throw JsonDecodeException();
        }
      } else {
        throw ServerException(
            message: response.data, code: response.statusCode);
      }
    } else {
      throw NetworkException();
    }
  }

  @override
  Future<List<PostModel>> getThreads({
    required BoardModel board,
    required Sort sort,
  }) async {
    if (await networkInfo.isConnected) {
      final response =
          await client.get<String>('$apiUrl/${board.board}/catalog.json');

      if (response.statusCode == 200) {
        try {
          List<PostModel> threads = List.empty(growable: true);
          List pages = jsonDecode(response.data!);

          for (var page in pages) {
            List opsInPage = page['threads'];
            for (var opInPage in opsInPage) {
              threads.add(PostModel.fromJson(opInPage));
            }
          }

          List<PostModel> sortedThreads = _sortThreads(threads, sort);

          return sortedThreads;
        } on Exception {
          throw JsonDecodeException();
        }
      } else {
        throw ServerException(
            message: response.data, code: response.statusCode);
      }
    } else {
      throw NetworkException();
    }
  }

  @override
  Future<void> postThread({
    required BoardModel board,
    required String captchaChallenge,
    required String captchaResponse,
    required PostModel post,
    String? filePath,
  }) async {
    if (await networkInfo.isConnected) {
      String url = "https://sys.4channel.org/${board.board}/post";

      FormData formData = FormData.fromMap({
        "name": post.name ?? '',
        "sub": post.sub ?? '',
        "pwd": '',
        "email": '',
        "com": post.com,
        "mode": 'regist',
        "t-challenge": captchaChallenge,
        "t-response": captchaResponse,
      });

      if (filePath != null) {
        formData.files.add(
          MapEntry(
            "upfile",
            await MultipartFile.fromFile(
              filePath,
              filename: filePath.split(Platform.pathSeparator).last,
            ),
          ),
        );
      }

      Map<String, String> headers = {
        "origin": "https://board.4channel.org",
        "referer": "https://board.4channel.org/",
      };

      Response<String>? response;

      response = await client.post(
        url,
        data: formData,
        options: Options(
          headers: headers,
        ),
      );

      String? error = _getErrorMessage(response);

      if (error != null) {
        throw ChanException(error);
      }
    } else {
      throw NetworkException();
    }
  }

  @override
  Future<void> postReply({
    required BoardModel board,
    required String captchaChallenge,
    required String captchaResponse,
    required PostModel resto,
    required PostModel post,
    String? filePath,
  }) async {
    if (await networkInfo.isConnected) {
      String url = "https://sys.4channel.org/${board.board}/post";

      FormData formData = FormData.fromMap({
        "name": post.name ?? '',
        "com": post.com ?? '',
        "mode": 'regist',
        "resto": resto.no,
        "t-challenge": captchaChallenge,
        "t-response": captchaResponse,
      });

      if (filePath != null) {
        formData.files.add(
          MapEntry(
            "upfile",
            await MultipartFile.fromFile(
              filePath,
              filename: filePath.split(Platform.pathSeparator).last,
            ),
          ),
        );
      }

      Map<String, String> headers = {
        "origin": "https://board.4channel.org",
        "referer": "https://board.4channel.org/",
      };
      Response<String>? response;

      response = await client.post(
        url,
        data: formData,
        options: Options(
          headers: headers,
        ),
      );

      String? error = _getErrorMessage(response);

      if (error != null) {
        throw ChanException(error);
      }
    } else {
      throw NetworkException();
    }
  }

  String? _getErrorMessage(Response<String>? response) {
    var document = parse(response?.data);
    Element? errMsg = document.getElementById('errmsg');
    if (errMsg != null) {
      return errMsg.innerHtml;
    }
  }

  List<PostModel> _sortThreads(List<PostModel> threads, Sort sort) {
    switch (sort.order) {
      case Order.byBump:
        return threads
          ..sort((a, b) {
            return a.lastModified!.compareTo(b.lastModified!);
          });
      case Order.byReplies:
        return threads
          ..sort((a, b) {
            return b.replies!.compareTo(a.replies!);
          });
      case Order.byImages:
        return threads
          ..sort((a, b) {
            return b.images!.compareTo(a.images!);
          });
      case Order.byNew:
        return threads
          ..sort((a, b) {
            return b.time.compareTo(a.time);
          });
      case Order.byOld:
        return threads
          ..sort((a, b) {
            return a.time.compareTo(b.time);
          });
    }
  }
}
