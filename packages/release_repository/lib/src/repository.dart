library release_repository;

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:release_repository/release_repository.dart';

/// Thrown if an exception occurs while making an `http` request.
class NetworkException implements Exception {}

/// Thrown if an excepton occurs while decoding the response body.
class JsonDecodeException implements Exception {}

class ReleaseRepository {
  final String apiUrl =
      'https://api.github.com/repos/Rukkaitto/mobichan/releases';

  Future<ReleaseModel> getLatestRelease() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      try {
        List<ReleaseModel> releases = (jsonDecode(response.body) as List)
            .map((model) => ReleaseModel.fromJson(model))
            .toList();
        return releases.first;
      } on Exception {
        throw JsonDecodeException();
      }
    } else {
      throw NetworkException();
    }
  }
}
