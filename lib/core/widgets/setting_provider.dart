import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobichan/features/setting/setting.dart';
import 'package:mobichan_domain/mobichan_domain.dart';
import 'package:string_similarity/string_similarity.dart';

class SettingProvider extends StatelessWidget {
  final String settingTitle;
  final Widget? loadingWidget;
  final Function(Setting setting) builder;

  const SettingProvider({
    required this.settingTitle,
    required this.builder,
    this.loadingWidget,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, List<Setting>?>(
      builder: (context, settings) {
        if (settings == null) {
          return loadingWidget ?? Container();
        }

        final setting = settings.findByTitle(settingTitle);

        if (setting == null) {
          final closestMatch =
              settingTitle.bestMatch(settings.map((s) => s.title).toList());

          var errorMessage = 'Setting "$settingTitle" not found.';

          if (closestMatch.bestMatch.rating! > 0.3) {
            errorMessage +=
                '\nDid you mean "${closestMatch.bestMatch.target}"?';
          }

          throw Exception(errorMessage);
        }

        return builder(setting);
      },
    );
  }
}
