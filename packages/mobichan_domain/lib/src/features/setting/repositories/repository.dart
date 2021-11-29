import 'package:mobichan_domain/mobichan_domain.dart';

abstract class SettingRepository {
  /// Gets a Setting from the cache
  Future<Setting?> getSetting(String key);

  /// Saves a Setting to the cache
  Future<List<Setting>> setSetting(Setting setting);

  /// Gets all settings from the cache
  Future<List<Setting>> getSettings();
}
