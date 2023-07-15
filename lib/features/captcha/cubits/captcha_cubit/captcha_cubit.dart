import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mobichan_data/mobichan_data.dart';
import 'package:mobichan_domain/mobichan_domain.dart';

part 'captcha_state.dart';

class CaptchaCubit extends Cubit<CaptchaState> {
  CaptchaCubit() : super(CaptchaLoading());

  void emitCaptchaLoaded(CaptchaChallenge captcha) {
    emit(CaptchaLoaded(captcha: captcha));
  }

  void emitCaptchaError(CaptchaChallengeException exception) {
    emit(CaptchaError('${exception.error} (wait for ${exception.refreshTime} seconds)'));
  }

  void emitCaptchaLoading() {
    emit(CaptchaLoading());
  }

  void emitCaptchaCloudflareChecking() {
    emit(CaptchaCloudflareChecking());
  }
}
