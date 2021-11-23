import 'package:flutter/material.dart';
import 'package:mobichan/features/captcha/captcha.dart';
import 'package:mobichan_domain/mobichan_domain.dart';

class CaptchaPopValues {
  final CaptchaChallenge captcha;
  final String attempt;

  CaptchaPopValues(this.captcha, this.attempt);
}

extension CaptchaPageHandlers on CaptchaPage {
  void handleValidate(
    BuildContext context,
    CaptchaChallenge captcha,
    String attempt,
  ) async {
    Navigator.of(context)
        .pop<CaptchaPopValues>(CaptchaPopValues(captcha, attempt));
  }
}
