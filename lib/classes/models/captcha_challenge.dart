class CaptchaChallenge {
  final String challenge;
  final int expireTime;
  final int refreshTime;
  final String foregroundImage;
  final int foregroundImageWidth;
  final int foregroundImageHeight;
  final String backgroundImage;
  final int backgroundImageWidth;

  CaptchaChallenge(
      {required this.challenge,
      required this.expireTime,
      required this.refreshTime,
      required this.foregroundImage,
      required this.foregroundImageWidth,
      required this.foregroundImageHeight,
      required this.backgroundImage,
      required this.backgroundImageWidth});

  factory CaptchaChallenge.fromJson(Map<String, dynamic> json) {
    return CaptchaChallenge(
      challenge: json['challenge'],
      expireTime: json['ttl'],
      refreshTime: json['cd'],
      foregroundImage: json['img'],
      foregroundImageWidth: json['img_width'],
      foregroundImageHeight: json['img_height'],
      backgroundImage: json['bg'],
      backgroundImageWidth: json['bg_width'],
    );
  }
}
