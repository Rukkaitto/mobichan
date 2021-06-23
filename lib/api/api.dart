import 'dart:convert';

import 'package:mobichan/classes/models/board.dart';
import 'package:http/http.dart' as http;
import 'package:mobichan/constants.dart';

Future<List<Board>> fetchBoards() async {
  final response = await http.get(Uri.parse(API_BOARDS_URL));

  if (response.statusCode == 200) {
    List<Board> boards = (json.decode(response.body)['boards'] as List)
        .map((model) => Board.fromJson(model))
        .toList();
    return boards;
  } else {
    throw Exception('Failed to load boards.');
  }
}
