import 'package:equatable/equatable.dart';
import 'package:collection/collection.dart';

enum SettingType {
  bool,
}

enum SettingGroup {
  general,
  appearance,
  media,
}

extension SettingGroupExtension on SettingGroup {
  String get title {
    switch (this) {
      case SettingGroup.general:
        return 'general';
      case SettingGroup.appearance:
        return 'appearance';
      case SettingGroup.media:
        return 'media';
    }
  }

  int compareTo(SettingGroup other) => index.compareTo(other.index);
}

class Setting extends Equatable {
  final String title;
  final dynamic value;
  final SettingType type;
  final SettingGroup group;

  const Setting({
    required this.title,
    required this.value,
    required this.type,
    required this.group,
  });

  @override
  List<Object?> get props => [title, value, type, group];
}

extension SettingListExtension on List<Setting> {
  Setting? findByTitle(String title) {
    return firstWhereOrNull((setting) => setting.title == title);
  }
}
