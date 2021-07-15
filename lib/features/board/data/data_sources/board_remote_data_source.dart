import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mobichan/core/error/exception.dart';
import 'package:mobichan/features/board/data/models/board_model.dart';

abstract class BoardRemoteDataSource {
  /// Calls the https://a.4cdn.org/boards.json endpoint.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<List<BoardModel>> getAllBoards();

  /// Calls the https://a.4cdn.org/boards.json endpoint
  /// and returns a board model depending on the code argument.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<BoardModel> getBoard(String code);
}

class BoardRemoteDataSourceImpl implements BoardRemoteDataSource {
  final http.Client client;

  BoardRemoteDataSourceImpl({required this.client});

  @override
  Future<List<BoardModel>> getAllBoards() async {
    final response = await _getResponse();

    if (response.statusCode == 200) {
      Iterable l = jsonDecode(response.body)['boards'];
      return List<BoardModel>.from(l.map((json) => BoardModel.fromJson(json)));
    } else {
      throw ServerException();
    }
  }

  @override
  Future<BoardModel> getBoard(String code) async {
    final response = await _getResponse();

    if (response.statusCode == 200) {
      Iterable l = jsonDecode(response.body)['boards'];
      return List<BoardModel>.from(l.map((json) => BoardModel.fromJson(json)))
          .firstWhere((element) => element.code == code);
    } else {
      throw ServerException();
    }
  }

  Future<http.Response> _getResponse() {
    return client.get(
      Uri.parse('https://a.4cdn.org/boards.json'),
      headers: {
        'Content-Type': 'application/json',
      },
    );
  }
}
