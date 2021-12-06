import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobichan/features/setting/setting.dart';
import 'package:mobichan_domain/mobichan_domain.dart';

class SettingProvider extends StatelessWidget {
  final String settingTitle;
  final Function(Setting setting) builder;

  const SettingProvider({
    required this.settingTitle,
    required this.builder,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, List<Setting>?>(
      builder: (context, settings) {
        if (settings == null) {
          return Container();
        }

        final setting = settings.findByTitle(settingTitle);

        if (setting == null) {
          throw Exception('Setting $settingTitle not found');
        }

        return builder(setting);
      },
    );
  }
}
