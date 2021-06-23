import 'dart:convert';

import 'package:mobichan/classes/models/board.dart';
import 'package:http/http.dart' as http;
import 'package:mobichan/classes/models/post.dart';
import 'package:mobichan/constants.dart';

Future<List<Board>> fetchBoards() async {
  final response = await http.get(Uri.parse(API_BOARDS_URL));

  if (response.statusCode == 200) {
    List<Board> boards = (jsonDecode(response.body)['boards'] as List)
        .map((model) => Board.fromJson(model))
        .toList();
    return boards;
  } else {
    throw Exception('Failed to load boards.');
  }
}

Future<List<Post>> fetchPosts(
    {required String board, required int thread}) async {
  final response =
      await http.get(Uri.parse('$API_URL/$board/thread/$thread.json'));

  if (response.statusCode == 200) {
    List<Post> posts = (jsonDecode(response.body)['posts'] as List)
        .map((model) => Post.fromJson(model))
        .toList();
    return posts;
  } else {
    throw Exception('Failed to load posts.');
  }
}

Future<List<Post>> fetchOPs({required String board}) async {
  final response = await http.get(Uri.parse('$API_URL/$board/catalog.json'));

  if (response.statusCode == 200) {
    List<Post> ops = List.empty(growable: true);
    List pages = jsonDecode(response.body);

    pages.forEach((page) {
      List opsInPage = page['threads'];
      opsInPage.forEach((opInPage) {
        ops.add(Post.fromJson(opInPage));
      });
    });

    return ops;
  } else {
    throw Exception('Failed to load OPs.');
  }
}
