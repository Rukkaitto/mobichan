import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import '../constants.dart';

class CaptchaWidget extends StatefulWidget {
  final Function(String response) onValidate;
  final Function()? onError;
  const CaptchaWidget({Key? key, this.onError, required this.onValidate})
      : super(key: key);

  @override
  _CaptchaWidgetState createState() => _CaptchaWidgetState();
}

class _CaptchaWidgetState extends State<CaptchaWidget> {
  bool hasError = false;

  void _captchaCallback(List args) {
    widget.onValidate(args.first);
  }

  void _onError(List args) {
    setState(() {
      hasError = true;
    });
    if (widget.onError != null) {
      widget.onError!();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        hasError
            ? Container(
                key: Key('error'),
              )
            : Container(),
        InAppWebView(
          initialData: InAppWebViewInitialData(data: """
              <html>
                <head>
                  <script src="https://www.google.com/recaptcha/api.js" async defer></script>
                  <style>
                    * {
                      transform: scale(1.30);
                      transform-origin: 0 0;
                    }
                    body {
                      background-color: rgb(48, 48, 48);
                    }
                  </style>
                </head>
                <body>
                  <div 
                    class="g-recaptcha" 
                    data-theme="dark"
                    data-sitekey="$CAPTCHA_SITE_KEY" 
                    data-callback="captchaCallback"
                    data-error-callback="onError"
                  >
                  </div>
                </body>
                <script>
                  window.captchaCallback = (token) => {
                    window.flutter_inappwebview.callHandler('captchaCallback', token);
                  }
                  
                  window.onError = () => {
                    window.flutter_inappwebview.callHandler('onError');
                  }
                </script>
              </html>
            """, baseUrl: Uri.https("boards.4channel.org", '/')),
          onWebViewCreated: (InAppWebViewController webViewController) {
            webViewController.addJavaScriptHandler(
                handlerName: "captchaCallback", callback: _captchaCallback);
            webViewController.addJavaScriptHandler(
                handlerName: "onError", callback: _onError);
          },
        ),
      ],
    );
  }
}
