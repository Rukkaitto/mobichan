import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobichan/dependency_injector.dart';
import 'package:mobichan/features/setting/setting.dart';
import 'package:mobichan_domain/mobichan_domain.dart';
import 'package:easy_localization/easy_localization.dart';

import 'settings_page.dart';

extension SettingsPageBuilders on SettingsPage {
  Widget buildListTile(Setting setting) {
    return BlocProvider<SettingCubit>(
      create: (context) => sl<SettingCubit>()..getSetting(setting.title),
      child: BlocBuilder<SettingCubit, Setting?>(
        builder: (context, setting) {
          if (setting != null) {
            return ListTile(
              title: Text(setting.title.tr()),
              trailing: buildSetter(setting),
            );
          }
          return Container();
        },
      ),
    );
  }

  Widget buildSetter(Setting setting) {
    return Builder(
      builder: (context) {
        if (setting.type == SettingType.bool) {
          return Switch(
            value: setting.value,
            onChanged: (value) => handleSettingChanged(
              context,
              setting,
              value,
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }
}
