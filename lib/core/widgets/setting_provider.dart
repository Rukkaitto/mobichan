import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobichan/features/setting/setting.dart';
import 'package:mobichan_domain/mobichan_domain.dart';
import 'package:string_similarity/string_similarity.dart';

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
          final closestMatch = settingTitle
              .bestMatch(settings.map((s) => s.title).toList())
              .bestMatch
              .target;

          var errorMessage = 'Setting "$settingTitle" not found.';

          if (closestMatch != null) {
            errorMessage += '\nDid you mean "$closestMatch"?';
          }

          throw Exception(errorMessage);
        }

        return builder(setting);
      },
    );
  }
}
