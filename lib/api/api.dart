import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';
import 'package:mobichan/classes/models/board.dart';
import 'package:http/http.dart' as http;
import 'package:mobichan/classes/models/post.dart';
import 'package:mobichan/constants.dart';
import 'package:mobichan/enums/enums.dart';
import 'package:mobichan/extensions/file_extension.dart';

class Api {
  static Future<List<Board>> fetchBoards() async {
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

  static Future<List<Post>> fetchPosts(
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

  static Future<List<Post>> fetchOPs(
      {required String board, Sort? sorting}) async {
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

      // Thread sorting
      if (sorting != null) {
        switch (sorting) {
          case Sort.byBumpOrder:
            ops.sort((a, b) {
              return a.lastModified!.compareTo(b.lastModified!);
            });
            break;
          case Sort.byReplyCount:
            ops.sort((a, b) {
              return b.replies!.compareTo(a.replies!);
            });
            break;
          case Sort.byImagesCount:
            ops.sort((a, b) {
              return b.images!.compareTo(a.images!);
            });
            break;
          case Sort.byNewest:
            ops.sort((a, b) {
              return b.time.compareTo(a.time);
            });
            break;
          case Sort.byOldest:
            ops.sort((a, b) {
              return a.time.compareTo(b.time);
            });
            break;
        }
      }

      return ops;
    } else {
      throw Exception('Failed to load OPs.');
    }
  }

  static void sendReply(
      {required String board,
      required String captchaResponse,
      required Function(Response<String> response) onPost,
      String? name,
      String? com,
      required int resto,
      PickedFile? pickedFile}) async {
    String url = "https://sys.4channel.org/$board/post";
    var dio = Dio();

    FormData formData = FormData.fromMap({
      "name": name ?? '',
      "com": com ?? '',
      "mode": 'regist',
      "resto": resto.toString(),
      "g-recaptcha-response": captchaResponse
    });

    if (pickedFile != null) {
      File file = File(pickedFile.path);
      formData.files.add(MapEntry(
        "upfile",
        await MultipartFile.fromFile(file.path, filename: file.name),
      ));
    }

    Map<String, String> headers = {
      "origin": "https://board.4channel.org",
      "referer": "https://board.4channel.org/",
    };

    Response<String> response = await dio.post(
      url,
      data: formData,
      options: Options(
        headers: headers,
      ),
    );
    onPost(response);
  }

  static void sendThread({
    required String board,
    required String captchaResponse,
    required Function(Response<String> response) onPost,
    String? name,
    String? subject,
    required String com,
    required PickedFile? pickedFile,
  }) async {
    String url = "https://sys.4channel.org/$board/post";
    var dio = Dio();

    FormData formData = FormData.fromMap({
      "name": name ?? '',
      "sub": subject ?? '',
      "pwd": '',
      "email": '',
      "com": com,
      "mode": 'regist',
      "g-recaptcha-response": captchaResponse,
    });

    if (pickedFile != null) {
      File file = File(pickedFile.path);
      formData.files.add(MapEntry(
        "upfile",
        await MultipartFile.fromFile(file.path, filename: file.name),
      ));
    }

    Map<String, String> headers = {
      "origin": "https://board.4channel.org",
      "referer": "https://board.4channel.org/",
    };

    Response<String> response = await dio.post(
      url,
      data: formData,
      options: Options(
        headers: headers,
      ),
    );
    onPost(response);
  }
}
