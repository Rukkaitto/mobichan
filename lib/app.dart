import 'package:captcha_repository/captcha_repository.dart';
import 'package:mobichan_domain/mobichan_domain.dart';
import 'package:post_repository/post_repository.dart';
import 'package:release_repository/release_repository.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobichan/constants.dart';
import 'package:mobichan/home.dart';
import 'package:mobichan/pages/boards/view/boards_view.dart';
import 'package:mobichan/pages/history_page.dart';
import 'package:mobichan/pages/settings_page.dart';

class App extends StatelessWidget {
  const App({
    Key? key,
    required BoardRepository boardRepository,
    required CaptchaRepository captchaRepository,
    required PostRepository postRepository,
    required ReleaseRepository releaseRepository,
  })  : _boardRepository = boardRepository,
        _captchaRepository = captchaRepository,
        _postRepository = postRepository,
        _releaseRepository = releaseRepository,
        super(key: key);

  final BoardRepository _boardRepository;
  final CaptchaRepository _captchaRepository;
  final PostRepository _postRepository;
  final ReleaseRepository _releaseRepository;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<BoardRepository>(
          create: (context) => _boardRepository,
        ),
        RepositoryProvider<CaptchaRepository>(
          create: (context) => _captchaRepository,
        ),
        RepositoryProvider<PostRepository>(
          create: (context) => _postRepository,
        ),
        RepositoryProvider<ReleaseRepository>(
          create: (context) => _releaseRepository,
        ),
      ],
      child: MaterialApp(
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          title: APP_TITLE,
          initialRoute: Home.routeName,
          routes: {
            Home.routeName: (context) => Home(),
            SettingsPage.routeName: (context) => SettingsPage(),
            HistoryPage.routeName: (context) => HistoryPage(),
            BoardsView.routeName: (context) => BoardsView(),
          },
          theme: ThemeData.dark().copyWith(
            pageTransitionsTheme: PageTransitionsTheme(builders: {
              TargetPlatform.android: CupertinoPageTransitionsBuilder(),
              TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
            }),
            colorScheme: ColorScheme.dark(primary: Colors.tealAccent),
          )),
    );
  }
}
