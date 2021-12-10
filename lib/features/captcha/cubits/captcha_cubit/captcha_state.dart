part of 'captcha_cubit.dart';

abstract class CaptchaState extends Equatable {
  const CaptchaState();

  @override
  List<Object> get props => [];
}

class CaptchaInitial extends CaptchaState {}

class CaptchaLoading extends CaptchaState {}

class CaptchaLoaded extends CaptchaState {
  final CaptchaChallenge captcha;

  const CaptchaLoaded({required this.captcha});

  @override
  List<Object> get props => [captcha];
}

class CaptchaError extends CaptchaState {
  final String message;

  const CaptchaError(this.message);

  @override
  List<Object> get props => [message];
}
