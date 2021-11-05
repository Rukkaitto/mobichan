import '../entities/entities.dart';
import '../../board/entities/entities.dart';
import '../../post/entities/entities.dart';

abstract class CaptchaRepository {
  Future<CaptchaChallenge> getCaptchaChallenge(Board board, Post? thread);
}
