import 'package:equatable/equatable.dart';
import 'package:collection/collection.dart';

enum SettingType {
  bool,
}

class Setting extends Equatable {
  final String title;
  final dynamic value;
  final SettingType type;

  const Setting({
    required this.title,
    required this.value,
    required this.type,
  });

  @override
  List<Object?> get props => [title, value, type];
}

extension SettingListExtension on List<Setting> {
  Setting? findByTitle(String title) {
    return firstWhereOrNull((setting) => setting.title == title);
  }
}
