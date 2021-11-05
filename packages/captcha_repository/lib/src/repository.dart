library captcha_repository;

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:captcha_repository/captcha_repository.dart';

/// Thrown if an exception occurs while making an `http` request.
class NetworkException implements Exception {}

/// Thrown if an excepton occurs while decoding the response body.
class JsonDecodeException implements Exception {}

class CaptchaRepository {
  final String apiUrl = '';
}
