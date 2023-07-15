import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobichan/features/captcha/captcha.dart';
import 'package:mobichan_data/mobichan_data.dart';
import 'package:mobichan_domain/mobichan_domain.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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

  Uri getCaptchaUri(Board board, Post? thread) {
    if (thread != null) {
      return Uri.parse(
          'https://sys.4channel.org/captcha?board=${board.board}&thread_id=${thread.no}');
    } else {
      return Uri.parse('https://sys.4channel.org/captcha?board=${board.board}');
    }
  }

  Future<void> handleWebViewFinished(BuildContext context, {required String url, required WebViewController webViewController}) async {
    final content = await webViewController.runJavaScriptReturningResult(
        'document.body.innerText',
        ) as String;

    try {
      // Remove the quotes and escape characters to allow parsing
      final contentJson = jsonDecode(content.substring(1, content.length - 1).replaceAll('\\', ''));

      if (content.contains('error')) {
        final error = CaptchaChallengeException.fromJson(contentJson);

        if (context.mounted) {
          context.read<CaptchaCubit>().emitCaptchaError(error);
        }
      } else if (content.contains('challenge')) {
        final CaptchaChallenge captchaChallenge = CaptchaChallengeModel.fromJson(contentJson);

        if (context.mounted) {
          context.read<CaptchaCubit>().emitCaptchaLoaded(captchaChallenge);
        }
      }
    } on FormatException {
      // If the content can't be parsed, it probably means that we're on the Cloudflare checking page
      if (context.mounted) {
        context.read<CaptchaCubit>().emitCaptchaCloudflareChecking();
      }
    }

  }
}
