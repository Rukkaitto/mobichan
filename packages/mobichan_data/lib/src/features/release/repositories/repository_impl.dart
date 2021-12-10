import 'package:mobichan_domain/mobichan_domain.dart';
import 'package:mobichan_data/mobichan_data.dart';

class ReleaseRepositoryImpl implements ReleaseRepository {
  final ReleaseRemoteDatasource remoteDatasource;

  ReleaseRepositoryImpl({required this.remoteDatasource});

  @override
  Future<Release> getLatestRelease() async {
    return remoteDatasource.getLatestRelease();
  }
}
