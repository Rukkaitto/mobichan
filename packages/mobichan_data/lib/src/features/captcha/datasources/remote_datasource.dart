import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:mobichan_data/mobichan_data.dart';

abstract class CaptchaRemoteDatasource {
  Future<CaptchaChallengeModel> getCaptchaChallenge(
      BoardModel board, PostModel? thread);
}

class CaptchaRemoteDatasourceImpl implements CaptchaRemoteDatasource {
  final String apiUrl = 'https://sys.4channel.org/captcha';
  final String errorKey = 'error';

  final Dio client;
  final NetworkInfo networkInfo;

  CaptchaRemoteDatasourceImpl(
      {required this.client, required this.networkInfo});

  @override
  Future<CaptchaChallengeModel> getCaptchaChallenge(
    BoardModel board,
    PostModel? thread,
  ) async {
    if (await networkInfo.isConnected) {
      String url = '$apiUrl?board=${board.board}';
      if (thread != null) {
        url += '&thread_id=${thread.no}';
      }
      final response = await client.get<String>(url);

      if (response.statusCode == 200) {
        Map<String, dynamic> responseJson = jsonDecode(response.data!);
        if (responseJson.containsKey(errorKey)) {
          throw CaptchaChallengeException.fromJson(responseJson);
        } else {
          CaptchaChallengeModel captchaChallenge =
              CaptchaChallengeModel.fromJson(responseJson);
          return captchaChallenge;
        }
      } else {
        throw ServerException(
          message: response.data,
          code: response.statusCode,
        );
      }
    } else {
      throw NetworkException();
    }
  }
}
