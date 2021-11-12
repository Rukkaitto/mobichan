import 'package:mobichan_domain/mobichan_domain.dart';

class SettingModel extends Setting {
  const SettingModel({
    required String title,
    required dynamic value,
    required SettingType type,
  }) : super(
          title: title,
          value: value,
          type: type,
        );

  factory SettingModel.fromEntity(Setting settings) {
    return SettingModel(
      title: settings.title,
      value: settings.value,
      type: settings.type,
    );
  }

  factory SettingModel.fromJson(Map<String, dynamic> json) {
    return SettingModel(
      title: json['title'],
      value: json['value'],
      type: getTypeFromString(json['type']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'value': value,
      'type': type.toString(),
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
}
