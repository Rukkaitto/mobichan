import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/models.dart';
import '../../../core/exceptions/exceptions.dart';

abstract class ReleaseRemoteDatasource {
  Future<ReleaseModel> getLatestRelease();
}

class ReleaseRemoteDatasourceImpl implements ReleaseRemoteDatasource {
  final String apiUrl =
      'https://api.github.com/repos/Rukkaitto/mobichan/releases';

  @override
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
