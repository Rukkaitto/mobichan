class CaptchaChallenge {
  final String challenge;
  final int expireTime;
  final int refreshTime;
  final String foregroundImage;
  final int foregroundImageWidth;
  final int foregroundImageHeight;
  final String backgroundImage;
  final int backgroundImageWidth;

  CaptchaChallenge({
    required this.challenge,
    required this.expireTime,
    required this.refreshTime,
    required this.foregroundImage,
    required this.foregroundImageWidth,
    required this.foregroundImageHeight,
    required this.backgroundImage,
    required this.backgroundImageWidth,
  });
}
