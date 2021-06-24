import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:http/http.dart' as http;

import '../constants.dart';

class Captcha extends StatefulWidget {
  const Captcha({Key? key}) : super(key: key);

  @override
  _CaptchaState createState() => _CaptchaState();
}

class _CaptchaState extends State<Captcha> {
  String captchaResponse = "";

  sendPost() async {
    const url = "https://sys.4channel.org/b/post";
    const resto = "857469340";
    const com = "no";
    const mode = "regist";

    Map<String, String> headers = {
      "origin": "https://board.4channel.org",
      "referer": "https://board.4channel.org/",
    };
    Map<String, String> body = {
      "com": com,
      "mode": mode,
      "resto": resto,
      "g-recaptcha-response": captchaResponse
    };
    await http
        .post(Uri.parse(url), headers: headers, body: body)
        .then((response) => print(response.body));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Captcha test'),
        ),
        body: InAppWebView(
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
                    'size': 'compact',
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
                handlerName: "captchaCallback",
                callback: (args) {
                  setState(() {
                    captchaResponse = args.first;
                  });
                });
          },
        ),
      ),
    );
  }
}
