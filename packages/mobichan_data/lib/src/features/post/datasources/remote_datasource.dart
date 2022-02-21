import 'dart:io';
import 'package:dio/dio.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';

import 'package:mobichan_data/mobichan_data.dart';

abstract class PostRemoteDatasource {
  Future<List<PostModel>> getPosts({
    required BoardModel board,
    required PostModel thread,
  });

  Future<List<PostModel>> getThreads(
      {required BoardModel board, required SortModel sort});

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

  final NetworkManager networkManager;

  PostRemoteDatasourceImpl({
    required this.networkManager,
  });

  @override
  Future<List<PostModel>> getPosts({
    required BoardModel board,
    required PostModel thread,
  }) async {
    final responseJson = await networkManager.makeRequest<Map<String, dynamic>>(
      url: '$apiUrl/${board.board}/thread/${thread.no}.json',
    );
    final maps = responseJson['posts'] as List;
    return List.generate(
      maps.length,
      (index) => PostModel.fromJson(maps[index]),
    );
  }

  @override
  Future<List<PostModel>> getThreads({
    required BoardModel board,
    required SortModel sort,
  }) async {
    final responseJson = await networkManager.makeRequest<List>(
      url: '$apiUrl/${board.board}/catalog.json',
    );
    List<PostModel> threads = List.empty(growable: true);

    for (var page in responseJson) {
      List opsInPage = page['threads'];
      for (var opInPage in opsInPage) {
        threads.add(PostModel.fromJson(opInPage));
      }
    }

    return threads.sortedBySort(sort);
  }

  @override
  Future<void> postThread({
    required BoardModel board,
    required String captchaChallenge,
    required String captchaResponse,
    required PostModel post,
    String? filePath,
  }) async {
    _post(
      board: board,
      captchaChallenge: captchaChallenge,
      captchaResponse: captchaResponse,
      post: post,
      filePath: filePath,
    );
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
    _post(
      board: board,
      captchaChallenge: captchaChallenge,
      captchaResponse: captchaResponse,
      resto: resto,
      post: post,
      filePath: filePath,
    );
  }

  void _post({
    required BoardModel board,
    required String captchaChallenge,
    required String captchaResponse,
    required PostModel post,
    PostModel? resto,
    String? filePath,
  }) async {
    FormData formData = FormData.fromMap({
      "name": post.name ?? '',
      "com": post.com,
      "mode": 'regist',
      "t-challenge": captchaChallenge,
      "t-response": captchaResponse,
    });

    if (resto != null) {
      formData.fields.add(
        MapEntry('resto', '${resto.no}'),
      );
    } else {
      formData.fields.add(
        MapEntry('sub', '${post.sub}'),
      );
    }

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

    final response = await networkManager.makeRequest<String>(
      url: 'https://sys.4channel.org/${board.board}/post',
      method: 'POST',
      data: formData,
      headers: headers,
    );

    final error = _getErrorMessage(response);

    if (error != null) {
      throw ChanException(error);
    }
  }

  String? _getErrorMessage(String data) {
    var document = parse(data);
    Element? errMsg = document.getElementById('errmsg');
    if (errMsg != null) {
      return errMsg.innerHtml;
    }
    return null;
  }
}
