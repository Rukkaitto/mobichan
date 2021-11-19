import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mobichan/dependency_injector.dart';
import 'package:mobichan/features/setting/setting.dart';
import 'package:mobichan/localization.dart';
import 'package:mobichan_domain/mobichan_domain.dart';

class SettingsPage extends StatelessWidget {
  static String routeName = '/settings';

  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SettingsCubit>(
      create: (context) => sl<SettingsCubit>()..getSettings(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(settings.tr()),
        ),
        body: BlocBuilder<SettingsCubit, List<Setting>?>(
          builder: (context, settings) {
            if (settings != null) {
              return ListView.builder(
                itemCount: settings.length,
                itemBuilder: (context, index) {
                  Setting setting = settings[index];
                  return ListTile(
                    title: Text(setting.title).tr(),
                    trailing: buildTrailing(setting.title),
                  );
                },
              );
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }
}
