import 'package:flutter/material.dart';
import 'package:mobichan/features/setting/setting.dart';
import 'package:mobichan_domain/mobichan_domain.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

extension SettingsPageHandlers on SettingsPage {
  void handleSettingChanged(
      BuildContext context, Setting setting, dynamic value) {
    context.read<SettingCubit>().updateSetting(setting, value);
  }
}
