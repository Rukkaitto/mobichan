import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import '../constants.dart';

class CaptchaWidget extends StatelessWidget {
  final Function(String response) onValidate;
  final Function()? onError;
  const CaptchaWidget({Key? key, this.onError, required this.onValidate})
      : super(key: key);

  void _captchaCallback(List args) {
    onValidate(args.first);
  }

  void _onError(List args) {
    if (onError != null) {
      onError!();
    }
  }

  @override
  Widget build(BuildContext context) {
    return InAppWebView(
      initialData: InAppWebViewInitialData(data: """
            <html>
              <head>
                <script src="https://www.google.com/recaptcha/api.js" async defer></script>
                <style>
                  * {
                    transform: scale(1.25);
                    transform-origin: 0 0;
                  }
                </style>
              </head>
              <body>
                <div 
                  class="g-recaptcha" 
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
    );
  }
}
