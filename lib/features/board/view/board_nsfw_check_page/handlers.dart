import 'package:mobichan/features/board/board.dart';

import 'board_nsfw_check_page.dart';

extension BoardNsfwCheckPageHandlers on BoardNsfwCheckPage {
  void handleOnButtonPressed(NsfwWarningCubit cubit) {
    cubit.dismiss();
  }
}
