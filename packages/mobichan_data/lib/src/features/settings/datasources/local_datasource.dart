import 'dart:convert';

import 'package:mobichan_data/mobichan_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class SettingLocalDatasource {
  Future<SettingModel?> getSetting(String key);

  Future<List<SettingModel>> setSetting(SettingModel setting);

  Future<List<SettingModel>> getSettings();

  Future<void> setSettings(List<SettingModel> settings);
}

class SettingLocalDatasourceImpl implements SettingLocalDatasource {
  final SharedPreferences sharedPreferences;

  SettingLocalDatasourceImpl({required this.sharedPreferences});

  String settingsKey = 'settings';

  @override
  Future<SettingModel?> getSetting(String key) async {
    List<SettingModel> settings = await getSettings();
    return settings.firstWhere((setting) => setting.title == key);
  }

  @override
  Future<List<SettingModel>> setSetting(SettingModel setting) async {
    List<SettingModel> settings = await getSettings();
    settings[settings.indexWhere((element) => element.title == setting.title)] =
        setting;
    setSettings(settings);
    return settings;
  }

  @override
  Future<List<SettingModel>> getSettings() async {
    List<String>? settingsEncoded =
        sharedPreferences.getStringList(settingsKey);
    if (settingsEncoded != null) {
      try {
        return settingsEncoded
            .map((settingEncoded) =>
                SettingModel.fromJson(jsonDecode(settingEncoded)))
            .toList();
      } catch (e) {
        return SettingModel.defaultSettings;
      }
    } else {
      // Default settings
      return SettingModel.defaultSettings;
    }
  }

  @override
  Future<void> setSettings(List<SettingModel> settings) async {
    sharedPreferences.setStringList(settingsKey,
        settings.map((setting) => jsonEncode(setting.toJson())).toList());
  }
}
