import 'package:captcha_repository/captcha_repository.dart';

class CaptchaChallenge extends CaptchaChallengeModel {
  CaptchaChallenge({
    required String challenge,
    required int expireTime,
    required int refreshTime,
    required String foregroundImage,
    required int foregroundImageWidth,
    required int foregroundImageHeight,
    required String backgroundImage,
    required int backgroundImageWidth,
  }) : super(
          challenge: challenge,
          expireTime: expireTime,
          refreshTime: refreshTime,
          foregroundImage: foregroundImage,
          foregroundImageWidth: foregroundImageWidth,
          foregroundImageHeight: foregroundImageHeight,
          backgroundImage: backgroundImage,
          backgroundImageWidth: backgroundImageWidth,
        );
}
