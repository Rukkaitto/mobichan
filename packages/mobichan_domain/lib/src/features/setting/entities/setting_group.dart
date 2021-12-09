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
