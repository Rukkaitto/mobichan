import 'package:mobichan/features/board/board.dart';

extension BoardNsfwCheckPageHandlers on BoardNsfwCheckPage {
  void handleOnButtonPressed(NsfwWarningCubit cubit) {
    cubit.dismiss();
  }
}
