import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:mobichan_data/mobichan_data.dart';

abstract class BoardRemoteDatasource {
  Future<List<BoardModel>> getBoards();
}

class BoardRemoteDatasourceImpl implements BoardRemoteDatasource {
  final Dio client;
  final NetworkInfo networkInfo;
  final String apiUrl = 'https://a.4cdn.org/boards.json';

  BoardRemoteDatasourceImpl({required this.client, required this.networkInfo});

  @override
  Future<List<BoardModel>> getBoards() async {
    if (await networkInfo.isConnected) {
      final response = await client.get<String>(apiUrl);

      if (response.statusCode == 200) {
        List<BoardModel> boards = (jsonDecode(response.data!)['boards'] as List)
            .map((model) => BoardModel.fromJson(model))
            .toList();
        return boards;
      } else {
        throw ServerException(
            message: response.data, code: response.statusCode);
      }
    } else {
      throw NetworkException();
    }
  }
}
