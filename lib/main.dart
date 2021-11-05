import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobichan/app.dart';
import 'package:mobichan_data/mobichan_data.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  runApp(
    EasyLocalization(
      supportedLocales: [Locale('en', 'US'), Locale('fr', 'FR')],
      path: 'assets/translations',
      fallbackLocale: Locale('en', 'US'),
      child: App(
        boardRepository: BoardRepositoryImpl(
          localDataSource: BoardLocalDataSourceImpl(),
          remoteDatasource: BoardRemoteDatasourceImpl(),
        ),
        captchaRepository: CaptchaRepositoryImpl(
          remoteDatasource: CaptchaRemoteDatasourceImpl(),
        ),
        postRepository: PostRepositoryImpl(
          localDatasource: PostLocalDatasourceImpl(),
          remoteDatasource: PostRemoteDatasourceImpl(),
        ),
        releaseRepository: ReleaseRepositoryImpl(
          remoteDatasource: ReleaseRemoteDatasourceImpl(),
        ),
      ),
    ),
  );
}
