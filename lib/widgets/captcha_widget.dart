import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import '../constants.dart';

class CaptchaWidget extends StatelessWidget {
  final Function(String response) onValidate;
  const CaptchaWidget({Key? key, required this.onValidate}) : super(key: key);

  void _captchaCallback(List args) {
    onValidate(args.first);
  }

  @override
  Widget build(BuildContext context) {
    return InAppWebView(
      initialData: InAppWebViewInitialData(data: """
            <!DOCTYPE html>
            <html>
            <head>
                <style type="text/css">
                * {
                    transform: scale(1.25);
                    transform-origin: 0 0;
                }

                #captcha-loading, #captcha-error {
                    font-family: sans-serif;
                    font-size: 18x;
                    text-align: center;
                    margin: 40px auto 0 auto;
                }
                </style>
            </head>
            <body>
            <div id="captcha-container"></div>
            <div id="captcha-error"></div>
            <div id="captcha-loading">Loading captcha&#8230;</div>

            <script type="text/javascript">
            (function() {
            window.globalOnCaptchaEntered = function(res) {
                window.flutter_inappwebview.callHandler('captchaCallback', res);
            }

            window.globalOnCaptchaLoaded = function() {
                grecaptcha.render('captcha-container', {
                    'sitekey': '$CAPTCHA_SITE_KEY',
                    'theme': 'light',
                    'callback': globalOnCaptchaEntered
                });
                document.getElementById('captcha-loading').style.display = 'none';
            }

            window.onerror = function(message, url, line) {
                document.getElementById('captcha-loading').style.display = 'none';
                document.getElementById('captcha-error').appendChild(document.createTextNode(
                    'Captcha error at ' + line + ': ' + message + ' @ ' + url));
            }
            })();
            </script>

            <script src='https://www.google.com/recaptcha/api.js?onload=globalOnCaptchaLoaded&render=explicit'></script>
            </body>
            </html>
          """, baseUrl: Uri.https("boards.4channel.org", '/')),
      onWebViewCreated: (InAppWebViewController webViewController) {
        webViewController.addJavaScriptHandler(
            handlerName: "captchaCallback", callback: _captchaCallback);
      },
    );
  }
}
