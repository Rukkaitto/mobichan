import '../entities/entities.dart';

abstract class CaptchaRepository {
  Future<CaptchaChallenge> getCaptchaChallenge(String board, int? thread);
}
