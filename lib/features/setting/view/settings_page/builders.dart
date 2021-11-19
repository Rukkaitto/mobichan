import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobichan/dependency_injector.dart';
import 'package:mobichan/features/setting/setting.dart';
import 'package:mobichan_domain/mobichan_domain.dart';

import 'settings_page.dart';

extension SettingsPageBuilders on SettingsPage {
  Widget buildTrailing(String key) {
    return BlocProvider<SettingCubit>(
      create: (context) => sl<SettingCubit>()..getSetting(key),
      child: BlocBuilder<SettingCubit, Setting?>(
        builder: (context, setting) {
          if (setting != null) {
            if (setting.type == SettingType.bool) {
              return Switch(
                value: setting.value,
                onChanged: (value) => handleSettingChanged(
                  context,
                  setting,
                  value,
                ),
              );
            }
          }
          return Container();
        },
      ),
    );
  }
}
