import 'package:board_repository/board_repository.dart';
import 'package:captcha_repository/captcha_repository.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobichan/app.dart';
import 'package:post_repository/post_repository.dart';
import 'package:release_repository/release_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  runApp(
    EasyLocalization(
      supportedLocales: [Locale('en', 'US'), Locale('fr', 'FR')],
      path: 'assets/translations',
      fallbackLocale: Locale('en', 'US'),
      child: App(
        boardRepository: BoardRepository(),
        captchaRepository: CaptchaRepository(),
        postRepository: PostRepository(),
        releaseRepository: ReleaseRepository(),
      ),
    ),
  );
}
