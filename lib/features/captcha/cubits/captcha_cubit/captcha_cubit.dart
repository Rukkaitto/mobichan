import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mobichan_domain/mobichan_domain.dart';

part 'captcha_state.dart';

class CaptchaCubit extends Cubit<CaptchaState> {
  final CaptchaRepository repository;

  CaptchaCubit({required this.repository}) : super(CaptchaInitial());

  void getCaptchaChallenge(Board board, Post? thread) async {
    emit(CaptchaLoading());
    try {
      final captcha = await repository.getCaptchaChallenge(board, thread);
      emit(CaptchaLoaded(captcha: captcha));
    } on Exception {
      emit(CaptchaError('Failed to get captcha.'));
    }
  }
}
