import 'package:mobichan_domain/mobichan_domain.dart';
import 'package:mobichan_data/mobichan_data.dart';

class CaptchaRepositoryImpl implements CaptchaRepository {
  final CaptchaRemoteDatasource remoteDatasource;

  CaptchaRepositoryImpl({required this.remoteDatasource});

  @override
  Future<CaptchaChallenge> getCaptchaChallenge(Board board, Post? thread) {
    return remoteDatasource.getCaptchaChallenge(
      BoardModel.fromEntity(board),
      thread != null ? PostModel.fromEntity(thread) : null,
    );
  }
}
