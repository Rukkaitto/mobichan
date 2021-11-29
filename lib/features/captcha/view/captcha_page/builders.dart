import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobichan/features/captcha/captcha.dart';
import 'package:mobichan_domain/mobichan_domain.dart';

extension CaptchaPageBuilders on CaptchaPage {
  Widget buildLoaded(BuildContext context, CaptchaChallenge challenge) {
    return CaptchaSliderWidget(
      backgroundImage: Image.memory(base64Decode(challenge.backgroundImage)),
      foregroundImage: Image.memory(base64Decode(challenge.foregroundImage)),
      captchaChallenge: challenge,
      onValidate: (attempt) => handleValidate(context, challenge, attempt),
    );
  }

  Widget buildLoading() {
    return const SizedBox(
      width: 100.0,
      height: 100.0,
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
