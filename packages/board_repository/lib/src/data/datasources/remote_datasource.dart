import 'dart:convert';

import 'package:board_repository/board_repository.dart';
import 'package:http/http.dart' as http;

abstract class BoardRemoteDatasource {
  Future<List<BoardModel>> getBoards();
}

class BoardRemoteDatasourceImpl implements BoardRemoteDatasource {
  final String apiUrl = 'https://a.4cdn.org/boards.json';

  @override
  Future<List<BoardModel>> getBoards() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      List<BoardModel> boards = (jsonDecode(response.body)['boards'] as List)
          .map((model) => BoardModel.fromJson(model))
          .toList();
      return boards;
    } else {
      throw NetworkException();
    }
  }
}
