import 'package:equatable/equatable.dart';
import 'package:collection/collection.dart';
import 'package:mobichan_domain/mobichan_domain.dart';

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
