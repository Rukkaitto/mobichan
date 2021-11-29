import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobichan_domain/mobichan_domain.dart';

class NsfwWarningCubit extends Cubit<bool> {
  final SettingRepository repository;
  NsfwWarningCubit({required this.repository}) : super(false);

  Future<void> checkNsfw(Board board) async {
    final Setting? nsfwWarning =
        await repository.getSetting('show_nsfw_warning');
    final bool showWarning = nsfwWarning?.value;

    emit(showWarning && board.wsBoard == 0);
  }

  void dismiss() => emit(false);
}
