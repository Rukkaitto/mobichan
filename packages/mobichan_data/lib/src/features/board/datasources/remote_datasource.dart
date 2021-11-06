import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:mobichan_data/mobichan_data.dart';

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
