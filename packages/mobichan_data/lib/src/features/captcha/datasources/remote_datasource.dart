import 'package:mobichan_data/mobichan_data.dart';

abstract class CaptchaRemoteDatasource {
  Future<CaptchaChallengeModel> getCaptchaChallenge(
      BoardModel board, PostModel? thread);
}

class CaptchaRemoteDatasourceImpl implements CaptchaRemoteDatasource {
  final String apiUrl = 'https://sys.4channel.org/captcha';
  final String errorKey = 'error';

  final NetworkManager networkManager;

  CaptchaRemoteDatasourceImpl({
    required this.networkManager,
  });

  @override
  Future<CaptchaChallengeModel> getCaptchaChallenge(
    BoardModel board,
    PostModel? thread,
  ) async {
    String url = '$apiUrl?board=${board.board}';
    if (thread != null) {
      url += '&thread_id=${thread.no}';
    }
    final responseJson = await networkManager.makeRequest<Map<String, dynamic>>(
      url: url,
    );
    if (responseJson.containsKey(errorKey)) {
      throw CaptchaChallengeException.fromJson(responseJson);
    } else {
      CaptchaChallengeModel captchaChallenge =
          CaptchaChallengeModel.fromJson(responseJson);
      return captchaChallenge;
    }
  }
}
