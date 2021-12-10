import '../entities/entities.dart';

abstract class ReleaseRepository {
  Future<Release> getLatestRelease();
}
