import '../datasources/datasources.dart';
import 'package:mobichan_domain/mobichan_domain.dart';

class ReleaseRepositoryImpl implements ReleaseRepository {
  final ReleaseRemoteDatasource remoteDatasource;

  ReleaseRepositoryImpl({required this.remoteDatasource});

  @override
  Future<Release> getLatestRelease() async {
    return remoteDatasource.getLatestRelease();
  }
}
