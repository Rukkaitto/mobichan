import 'package:flutter/material.dart';
import 'package:mobichan/features/setting/setting.dart';
import 'package:mobichan_domain/mobichan_domain.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

extension SettingsPageHandlers on SettingsPage {
  void handleSettingChanged(
      BuildContext context, Setting setting, dynamic value) {
    final newSetting = Setting(
      title: setting.title,
      value: value,
      type: setting.type,
      group: setting.group,
    );
    context.read<SettingsCubit>().updateSetting(newSetting);
  }
}
