import 'package:mobichan_domain/mobichan_domain.dart';
import '../datasources/datasources.dart';

class CaptchaRepositoryImpl implements CaptchaRepository {
  final CaptchaRemoteDatasource remoteDatasource;

  CaptchaRepositoryImpl({required this.remoteDatasource});

  @override
  Future<CaptchaChallenge> getCaptchaChallenge(String board, int? thread) {
    return remoteDatasource.getCaptchaChallenge(board, thread);
  }
}
