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

void sendPost(
    {required String board,
    required String captchaResponse,
    required Function(String response) onPost,
    String? name,
    String? com,
    required int resto}) async {
  String url = "https://sys.4channel.org/$board/post";
  const mode = "regist";

  Map<String, String> headers = {
    "origin": "https://board.4channel.org",
    "referer": "https://board.4channel.org/",
  };
  Map<String, String> body = {
    "name": name ?? '',
    "com": com ?? '',
    "mode": mode,
    "resto": resto.toString(),
    "g-recaptcha-response": captchaResponse
  };
  await http
      .post(Uri.parse(url), headers: headers, body: body)
      .then((response) => onPost(response.body));
}

void sendThread({
  required String board,
  required String captchaResponse,
  required Function(String response) onPost,
  String? name,
  String? subject,
  required String com,
}) async {
  String url = "https://sys.4channel.org/$board/post";
  const mode = "regist";

  Map<String, String> headers = {
    "origin": "https://board.4channel.org",
    "referer": "https://board.4channel.org/",
  };
  Map<String, String> body = {
    "name": name ?? '',
    "sub": subject ?? '',
    "com": com,
    "mode": mode,
    "g-recaptcha-response": captchaResponse
  };
  await http
      .post(Uri.parse(url), headers: headers, body: body)
      .then((response) => onPost(response.body));
}
