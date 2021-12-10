/// Thrown if an exception occurs when the challenge is requested repeatedly.
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
