import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
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

  Future<PostModel> postThread({
    required BoardModel board,
    required String captchaChallenge,
    required String captchaResponse,
    required PostModel post,
    String? filePath,
  });

  Future<PostModel> postReply({
    required BoardModel board,
    required String captchaChallenge,
    required String captchaResponse,
    required PostModel resto,
    required PostModel post,
    String? filePath,
  });

  Future<void> saveToFirestore({
    required PostModel post,
    required PostModel resto,
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
  Future<PostModel> postThread({
    required BoardModel board,
    required String captchaChallenge,
    required String captchaResponse,
    required PostModel post,
    String? filePath,
  }) async {
    return _post(
      board: board,
      captchaChallenge: captchaChallenge,
      captchaResponse: captchaResponse,
      post: post,
      filePath: filePath,
    );
  }

  @override
  Future<PostModel> postReply({
    required BoardModel board,
    required String captchaChallenge,
    required String captchaResponse,
    required PostModel resto,
    required PostModel post,
    String? filePath,
  }) async {
    return _post(
      board: board,
      captchaChallenge: captchaChallenge,
      captchaResponse: captchaResponse,
      resto: resto,
      post: post,
      filePath: filePath,
    );
  }

  Future<PostModel> _post({
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

    return PostModel(
      no: _getCreatedPostNo(response),
      resto: resto?.no ?? 0,
      boardId: board.board,
      boardTitle: board.title,
      boardWs: board.wsBoard,
      sub: post.sub,
      com: post.com,
      name: post.name,
    );
  }

  String? _getErrorMessage(String data) {
    var document = parse(data);
    Element? errMsg = document.getElementById('errmsg');
    if (errMsg != null) {
      return errMsg.innerHtml;
    }
    return null;
  }

  int _getCreatedPostNo(String data) {
    final regExp = RegExp(r'(?<=no:)\d+');
    final match = regExp.firstMatch(data)?.group(0);
    return int.parse(match!);
  }

  @override
  Future<void> saveToFirestore({
    required PostModel post,
    required PostModel resto,
  }) async {
    final token = await FirebaseMessaging.instance.getToken();
    FirebaseFirestore.instance.collection('users').doc(post.no.toString()).set({
      'token': token,
      'thread': resto.no,
      'replyTo': post.replyingToNo(),
      'post': post.toJson(),
      'notification_sent': false,
    });
  }
}
