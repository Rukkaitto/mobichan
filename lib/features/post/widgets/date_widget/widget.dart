import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mobichan/core/core.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:mobichan_domain/mobichan_domain.dart';

class DateWidget extends StatelessWidget {
  final Post post;
  final bool inDialog;
  final bool inGrid;

  const DateWidget(
      {required this.post,
      this.inDialog = false,
      this.inGrid = false,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: !inGrid,
      child: SettingProvider(
        settingTitle: 'full_dates',
        builder: (fullDatesSetting) {
          return Builder(
            builder: (context) {
              if (post.time == 0) return Container();
              final date =
                  DateTime.fromMillisecondsSinceEpoch(post.time * 1000);

              String formattedDate;
              if (fullDatesSetting.value) {
                formattedDate = DateFormat.Md(context.locale.languageCode)
                    .add_Hm()
                    .format(date);
              } else {
                formattedDate = timeago.format(
                  date,
                  locale: inDialog ? 'en_short' : context.locale.languageCode,
                );
              }
              return Text(
                formattedDate,
                style: Theme.of(context).textTheme.bodySmall,
              );
            },
          );
        },
      ),
    );
  }
}
