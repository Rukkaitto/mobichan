import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobichan/features/captcha/captcha.dart';
import 'package:mobichan_domain/mobichan_domain.dart';

extension CaptchaPageBuilders on CaptchaPage {
  Widget buildLoaded(CaptchaChallenge challenge) {
    return CaptchaSliderWidget(
      backgroundImage: Image.memory(base64Decode(challenge.backgroundImage)),
      foregroundImage: Image.memory(base64Decode(challenge.foregroundImage)),
      captchaChallenge: challenge,
      onValidate: (attempt) => handleOnValidate(context, challenge, attempt),
    );
  }

  Widget buildLoading() {
    return Container(
      width: 100.0,
      height: 100.0,
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
