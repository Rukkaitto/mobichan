import 'package:flutter/material.dart';
import 'package:mobichan/features/setting/setting.dart';
import 'package:mobichan_domain/mobichan_domain.dart';
import 'package:easy_localization/easy_localization.dart';

import 'settings_page.dart';

extension SettingsPageBuilders on SettingsPage {
  Widget buildListTile(Setting setting) {
    return Builder(builder: (context) {
      return ListTile(
        title: Text(
          setting.title.tr(),
          style: Theme.of(context).textTheme.bodyText2,
        ),
        trailing: buildSetter(setting),
      );
    });
  }

  Widget buildGroupSeparator(SettingGroup group) {
    return Builder(builder: (context) {
      return Padding(
        padding: const EdgeInsets.only(top: 8.0, left: 8.0),
        child: Text(
          group.title,
          style: Theme.of(context).textTheme.headline6,
        ).tr(),
      );
    });
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
