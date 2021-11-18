import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mobichan/features/board/board.dart';
import 'package:mobichan/localization.dart';

class NsfwWarningPage extends StatelessWidget {
  final Function() onDismiss;
  const NsfwWarningPage({Key? key, required this.onDismiss}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(nsfw_warning).tr(),
      ),
      drawer: BoardDrawer(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(nsfw_warning_message).tr(),
            ElevatedButton(
              onPressed: onDismiss,
              child: Text(nsfw_warning_enter).tr(),
            ),
          ],
        ),
      ),
    );
  }
}
