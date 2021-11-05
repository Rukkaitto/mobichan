import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:mobichan/classes/exceptions/captcha_challenge_exception.dart';
import 'package:mobichan/classes/models/captcha_challenge.dart';
import 'package:mobichan/classes/models/post.dart';
import 'package:mobichan/classes/models/release.dart';
import 'package:mobichan/constants.dart';
import 'package:mobichan/enums/enums.dart';
import 'package:mobichan/extensions/file_extension.dart';

class Api {
  static Future<CaptchaChallenge> fetchCaptchaChallenge(
      String board, int? thread) async {
    String url = '$API_CAPTCHA_URL?board=$board';
    if (thread != null) {
      url += '&thread_id=$thread';
    }
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      Map<String, dynamic> responseJson = jsonDecode(response.body);
      if (responseJson.containsKey('error')) {
        throw CaptchaChallengeException.fromJson(responseJson);
      } else {
        CaptchaChallenge captchaChallenge =
            CaptchaChallenge.fromJson(responseJson);
        return captchaChallenge;
      }
    } else {
      throw Exception('Failed to get captcha challenge');
    }
  }

  static Future<Release> fetchLatestRelease() async {
    final response = await http.get(Uri.parse("$API_RELEASES_URL"));

    if (response.statusCode == 200) {
      List<Release> releases = (jsonDecode(response.body) as List)
          .map((model) => Release.fromJson(model))
          .toList();
      return releases.first;
    } else {
      throw Exception('Failed to fetch releases');
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
      required String captchaChallenge,
      required String captchaResponse,
      required Function(Response<String> response) onPost,
      String? name,
      String? com,
      required int resto,
      XFile? pickedFile}) async {
    String url = "https://sys.4channel.org/$board/post";
    var dio = Dio();

    FormData formData = FormData.fromMap({
      "name": name ?? '',
      "com": com ?? '',
      "mode": 'regist',
      "resto": resto.toString(),
      "t-challenge": captchaChallenge,
      "t-response": captchaResponse,
    });

    print(captchaChallenge);
    print(captchaResponse);

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
    required String captchaChallenge,
    required String captchaResponse,
    required Function(Response<String> response) onPost,
    String? name,
    String? subject,
    required String com,
    required XFile? pickedFile,
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
      "t-challenge": captchaChallenge,
      "t-response": captchaResponse,
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
