import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mobichan/core/widgets/responsive_width.dart';
import 'package:mobichan/features/setting/setting.dart';
import 'package:mobichan/localization.dart';
import 'package:mobichan_domain/mobichan_domain.dart';
import 'package:grouped_list/grouped_list.dart';

class SettingsPage extends StatelessWidget {
  static String routeName = '/settings';

  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(settings.tr()),
      ),
      body: BlocBuilder<SettingsCubit, List<Setting>?>(
        builder: (context, settings) {
          if (settings != null) {
            return GroupedListView<Setting, SettingGroup>(
              elements: settings,
              groupBy: (setting) => setting.group,
              groupComparator: (a, b) => a.compareTo(b),
              groupSeparatorBuilder: (group) => buildGroupSeparator(group),
              itemBuilder: (context, setting) {
                return ResponsiveWidth(child: buildListTile(setting));
              },
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
