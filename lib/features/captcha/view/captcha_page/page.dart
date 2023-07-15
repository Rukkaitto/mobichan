import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobichan/dependency_injector.dart';
import 'package:mobichan/features/captcha/captcha.dart';
import 'package:mobichan/core/core.dart';
import 'package:mobichan_domain/mobichan_domain.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CaptchaPage extends StatelessWidget {
  final Board board;
  final Post? thread;

  CaptchaPage({required this.board, this.thread, Key? key})
      : super(key: key);

  final WebViewController _webViewController = WebViewController()..setJavaScriptMode(JavaScriptMode.unrestricted);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Theme.of(context).cardColor,
      child: BlocProvider<CaptchaCubit>(
        create: (context) => sl<CaptchaCubit>(),
        child: Stack(
          alignment: Alignment.center,
          children: [
            BlocConsumer<CaptchaCubit, CaptchaState>(
              listener: (context, state) {
                if (state is CaptchaError) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context)
                    .showSnackBar(errorSnackbar(context, state.message));
                }
              },
              builder: (context, state) {
                if (state is CaptchaCloudflareChecking) {
                  return buildCloudflareChecking();
                } else if (state is CaptchaLoaded) {
                  return buildLoaded(context, state.captcha);
                } else if (state is CaptchaLoading) {
                  return buildLoading();
                } else {
                  return Container();
                }
              }, 
            ),
            Offstage(
              child: Builder(
                builder: (context) {
                  return WebViewWidget(
                    controller: _webViewController
                      ..setNavigationDelegate(NavigationDelegate(
                        onPageFinished: (url) async {
                          await handleWebViewFinished(
                            context, 
                            url: url, 
                            webViewController: _webViewController
                          );
                        },
                    ))
                    ..loadRequest(getCaptchaUri(board, thread)),
                  );
                }
              ),
            ),
          ],
        ),
      ),
    );
  }
}
