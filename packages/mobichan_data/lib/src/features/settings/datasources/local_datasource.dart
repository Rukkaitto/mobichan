import 'dart:convert';

import 'package:mobichan_data/mobichan_data.dart';
import 'package:mobichan_domain/mobichan_domain.dart';
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
      return settingsEncoded
          .map((settingEncoded) =>
              SettingModel.fromJson(jsonDecode(settingEncoded)))
          .toList();
    } else {
      // Default settings
      return [
        const SettingModel(
          title: 'show_nsfw_warning',
          value: true,
          type: SettingType.bool,
          group: SettingGroup.general,
        ),
        const SettingModel(
          title: 'threaded_replies',
          value: true,
          type: SettingType.bool,
          group: SettingGroup.appearance,
        ),
        const SettingModel(
          title: 'grid_view',
          value: false,
          type: SettingType.bool,
          group: SettingGroup.appearance,
        ),
        const SettingModel(
          title: 'high_res_thumbnails_mobile',
          value: false,
          type: SettingType.bool,
          group: SettingGroup.appearance,
        ),
        const SettingModel(
          title: 'high_res_thumbnails_wifi',
          value: true,
          type: SettingType.bool,
          group: SettingGroup.appearance,
        ),
        const SettingModel(
          title: 'mute_webm',
          value: false,
          type: SettingType.bool,
          group: SettingGroup.media,
        ),
      ];
    }
  }

  @override
  Future<void> setSettings(List<SettingModel> settings) async {
    sharedPreferences.setStringList(settingsKey,
        settings.map((setting) => jsonEncode(setting.toJson())).toList());
  }
}
