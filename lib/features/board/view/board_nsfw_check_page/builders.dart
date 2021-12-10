import 'package:flutter/material.dart';
import 'package:mobichan/features/board/board.dart';
import 'package:mobichan/localization.dart';
import 'package:easy_localization/easy_localization.dart';

import 'board_nsfw_check_page.dart';

extension BoardNsfwCheckPageBuilders on BoardNsfwCheckPage {
  Widget buildWarning(NsfwWarningCubit cubit) {
    return Scaffold(
      appBar: AppBar(
        title: Text('nsfw_warning'.tr()),
      ),
      drawer: const BoardDrawer(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(kNsfwWarningMessage).tr(),
            ElevatedButton(
              onPressed: () => handleOnButtonPressed(cubit),
              child: const Text(kNsfwWarningEnter).tr(),
            ),
          ],
        ),
      ),
    );
  }
}
