import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:mobichan_data/mobichan_data.dart';

abstract class ReleaseRemoteDatasource {
  Future<ReleaseModel> getLatestRelease();
}

class ReleaseRemoteDatasourceImpl implements ReleaseRemoteDatasource {
  final String apiUrl =
      'https://api.github.com/repos/Rukkaitto/mobichan/releases';

  final http.Client client;

  ReleaseRemoteDatasourceImpl({required this.client});

  @override
  Future<ReleaseModel> getLatestRelease() async {
    final response = await client.get(Uri.parse(apiUrl));

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
