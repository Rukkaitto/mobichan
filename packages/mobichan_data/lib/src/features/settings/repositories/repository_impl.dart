import 'package:mobichan_data/mobichan_data.dart';
import 'package:mobichan_domain/mobichan_domain.dart';

class SettingRepositoryImpl implements SettingRepository {
  final SettingLocalDatasource localDatasource;

  SettingRepositoryImpl({required this.localDatasource});

  @override
  Future<Setting?> getSetting(String key) async {
    return localDatasource.getSetting(key);
  }

  @override
  Future<List<Setting>> setSetting(Setting settings) async {
    return localDatasource.setSetting(SettingModel.fromEntity(settings));
  }

  @override
  Future<List<Setting>> getSettings() async {
    return localDatasource.getSettings();
  }
}
