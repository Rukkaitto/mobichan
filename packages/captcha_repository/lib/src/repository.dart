library captcha_repository;

import 'dart:convert';

import 'package:captcha_repository/captcha_repository.dart';
import 'package:http/http.dart' as http;

/// Thrown if an exception occurs while making an `http` request.
class NetworkException implements Exception {}

/// Thrown if an excepton occurs while decoding the response body.
class JsonDecodeException implements Exception {}

/// Thrown if an exception occurs when the submitted captcha is wrong.
class CaptchaChallengeException implements Exception {
  final String error;
  final int refreshTime;

  CaptchaChallengeException({required this.error, required this.refreshTime});

  factory CaptchaChallengeException.fromJson(Map<String, dynamic> json) {
    return CaptchaChallengeException(
      error: json['error'],
      refreshTime: json['cd'],
    );
  }
}

class CaptchaRepository {
  final String apiUrl = 'https://sys.4channel.org/captcha';

  Future<CaptchaChallenge> fetchCaptchaChallenge(
    String board,
    int? thread,
  ) async {
    String url = '$apiUrl?board=$board';
    if (thread != null) {
      url += '&thread_id=$thread';
    }
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      try {
        Map<String, dynamic> responseJson = jsonDecode(response.body);
        if (responseJson.containsKey('error')) {
          throw CaptchaChallengeException.fromJson(responseJson);
        } else {
          CaptchaChallenge captchaChallenge =
              CaptchaChallenge.fromJson(responseJson);
          return captchaChallenge;
        }
      } on Exception {
        throw JsonDecodeException();
      }
    } else {
      throw Exception('Failed to get captcha challenge');
    }
  }
}
