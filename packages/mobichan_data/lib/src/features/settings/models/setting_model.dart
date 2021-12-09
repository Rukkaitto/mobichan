import 'package:mobichan_domain/mobichan_domain.dart';

class SettingModel extends Setting {
  const SettingModel({
    required String title,
    required dynamic value,
    required SettingType type,
    required SettingGroup group,
  }) : super(
          title: title,
          value: value,
          type: type,
          group: group,
        );

  factory SettingModel.fromEntity(Setting settings) {
    return SettingModel(
      title: settings.title,
      value: settings.value,
      type: settings.type,
      group: settings.group,
    );
  }

  factory SettingModel.fromJson(Map<String, dynamic> json) {
    return SettingModel(
      title: json['title'],
      value: json['value'],
      type: getTypeFromString(json['type']),
      group: getGroupFromString(json['group']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'value': value,
      'type': type.toString(),
      'group': group.toString(),
    };
  }

  static SettingType getTypeFromString(String typeAsString) {
    for (SettingType element in SettingType.values) {
      if (element.toString() == typeAsString) {
        return element;
      }
    }
    return SettingType.bool;
  }

  static SettingGroup getGroupFromString(String groupAsString) {
    for (SettingGroup element in SettingGroup.values) {
      if (element.toString() == groupAsString) {
        return element;
      }
    }
    return SettingGroup.general;
  }
}
