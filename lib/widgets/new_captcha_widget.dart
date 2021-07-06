import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import '../constants.dart';

class NewCaptchaWidget extends StatefulWidget {
  final Function(String response) onValidate;
  final Function()? onError;
  const NewCaptchaWidget({Key? key, this.onError, required this.onValidate})
      : super(key: key);

  @override
  _NewCaptchaWidgetState createState() => _NewCaptchaWidgetState();
}

class _NewCaptchaWidgetState extends State<NewCaptchaWidget> {
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
          onConsoleMessage: (controller, consoleMessage) {
            print("WebView: " + consoleMessage.message);
          },
          initialData: InAppWebViewInitialData(data: r"""
            <html>
            <head>
              <script defer>
                window.onload = function () {
                  initTCaptcha();
                }
                function initTCaptcha() {
                  let e = document.getElementById("t-root");
                  console.log(e);
                  if (e) {
                    let t, n = location.pathname.split(new RegExp('/\//'))[1];
                    t = document.forms.post && document.forms.post.resto ? +document.forms.post.resto.value : 0,
                      TCaptcha.init(e, n, t),
                      TCaptcha.setErrorCb(window.showPostFormError)
                  }
                }
                var TCaptcha = {
                  node: null,
                  imgCntNode: null,
                  bgNode: null,
                  fgNode: null,
                  sliderNode: null,
                  respNode: null,
                  reloadNode: null,
                  helpNode: null,
                  challengeNode: null,
                  challenge: null,
                  reloadTimeout: null,
                  expireTimeout: null,
                  errorCb: null,
                  path: "/captcha",
                  init: function (e, t, n) {
                    this.node && this.destroy(),
                      this.node = e,
                      this.imgCntNode = this.buildImgCntNode(),
                      this.bgNode = this.buildImgNode("bg"),
                      this.fgNode = this.buildImgNode("fg"),
                      this.sliderNode = this.buildSliderNode(),
                      this.respNode = this.buildRespField(),
                      this.reloadNode = this.buildReloadNode(t, n),
                      this.helpNode = this.buildHelpNode(),
                      this.challengeNode = this.buildChallengeNode(),
                      e.appendChild(this.reloadNode),
                      e.appendChild(this.respNode),
                      e.appendChild(this.helpNode),
                      this.imgCntNode.appendChild(this.bgNode),
                      this.imgCntNode.appendChild(this.fgNode),
                      e.appendChild(this.imgCntNode),
                      e.appendChild(this.sliderNode),
                      e.appendChild(this.challengeNode)
                  },
                  destroy: function () {
                    let e = TCaptcha;
                    e.node && (clearTimeout(e.reloadTimeout),
                      clearTimeout(e.expireTimeout),
                      e.node.textContent = "",
                      e.node = null,
                      e.imgCntNode = null,
                      e.bgNode = null,
                      e.fgNode = null,
                      e.sliderNode = null,
                      e.respNode = null,
                      e.reloadNode = null,
                      e.helpNode = null,
                      e.challengeNode = null,
                      e.challenge = null,
                      e.errorCb = null)
                  },
                  setErrorCb: function (e) {
                    TCaptcha.errorCb = e
                  },
                  buildImgCntNode: function () {
                    let e = document.createElement("div");
                    return e.id = "t-cnt",
                      e.style.height = "80px",
                      e.style.marginTop = "2px",
                      e.style.position = "relative",
                      e
                  },
                  buildImgNode: function (e) {
                    let t = document.createElement("div");
                    return t.id = "t-" + e,
                      t.style.width = "100%",
                      t.style.height = "100%",
                      t.style.position = "absolute",
                      t.style.backgroundRepeat = "no-repeat",
                      t.style.backgroundPosition = "top left",
                      t
                  },
                  buildRespField: function () {
                    let e = document.createElement("input");
                    return e.id = "t-resp",
                      e.name = "t-response",
                      e.placeholder = "Type the CAPTCHA here",
                      e.setAttribute("autocomplete", "off"),
                      e.type = "text",
                      e.style.width = "160px",
                      e.style.boxSizing = "border-box",
                      e.style.textTransform = "uppercase",
                      e.style.fontSize = "11px",
                      e.style.height = "18px",
                      e.style.margin = "0",
                      e.style.padding = "0 2px",
                      e.style.fontFamily = "monospace",
                      e.style.verticalAlign = "middle",
                      e
                  },
                  buildSliderNode: function () {
                    let e = document.createElement("input");
                    return e.id = "t-slider",
                      e.setAttribute("autocomplete", "off"),
                      e.type = "range",
                      e.style.width = "100%",
                      e.style.boxSizing = "border-box",
                      e.style.visibility = "hidden",
                      e.style.margin = "0",
                      e.value = 0,
                      e.min = 0,
                      e.max = 100,
                      e.addEventListener("input", this.onSliderInput, !1),
                      e
                  },
                  buildChallengeNode: function () {
                    let e = document.createElement("input");
                    return e.name = "t-challenge",
                      e.type = "hidden",
                      e
                  },
                  buildReloadNode: function (e, t) {
                    let n = document.createElement("button");
                    return n.id = "t-load",
                      n.type = "button",
                      n.style.fontSize = "11px",
                      n.style.padding = "0",
                      n.style.width = "90px",
                      n.style.boxSizing = "border-box",
                      n.style.margin = "0 6px 0 0",
                      n.style.verticalAlign = "middle",
                      n.style.height = "18px",
                      n.textContent = "Get Captcha",
                      n.setAttribute("data-board", e),
                      n.setAttribute("data-tid", t),
                      n.addEventListener("click", this.onReloadClick, !1),
                      n
                  },
                  buildHelpNode: function () {
                    let e = document.createElement("button");
                    return e.id = "t-help",
                      e.type = "button",
                      e.style.fontSize = "11px",
                      e.style.padding = "0",
                      e.style.width = "20px",
                      e.style.boxSizing = "border-box",
                      e.style.margin = "0 0 0 6px",
                      e.style.verticalAlign = "middle",
                      e.style.height = "18px",
                      e.textContent = "?",
                      e.setAttribute("data-tip", "Help"),
                      e.tabIndex = -1,
                      e.addEventListener("click", this.onHelpClick, !1),
                      e
                  },
                  onHelpClick: function () {
                    alert("- Only type letters and numbers displayed in the image.\n- If needed, use the slider to align the image to make it readable.\n- Make sure to not block any cookies set by 4chan.")
                  },
                  onReloadClick: function () {
                    let e = this.getAttribute("data-board")
                      , t = this.getAttribute("data-tid");
                    TCaptcha.toggleReloadBtn(!1, "Loading"),
                      TCaptcha.load(e, t)
                  },
                  load: function (e, t) {
                    let n;
                    clearTimeout(TCaptcha.reloadTimeout),
                      clearTimeout(TCaptcha.expireTimeout),
                      n = -1 !== location.host.indexOf(".4channel.org") ? "4channel" : "4chan";
                    let o = [];
                    e && o.push("board=" + e),
                      t > 0 && o.push("thread_id=" + t),
                      o.length > 0 && (o = "?" + o.join("&")),
                      fetch("https://sys." + n + ".org" + TCaptcha.path + o, {
                        credentials: "include"
                      }).then(e => {
                        if (!e.ok)
                          throw new Error("Bad HTTP Status");
                        return e.json()
                      }
                      ).then(e => {
                        TCaptcha.buildFromJson(e)
                      }
                      )["catch"](e => {
                        TCaptcha.toggleReloadBtn(!0, "Get Captcha"),
                          console.log(e),
                          TCaptcha.errorCb && TCaptcha.errorCb.call(null, e)
                      }
                      )
                  },
                  toggleReloadBtn: function (e, t) {
                    let n = TCaptcha;
                    n.reloadNode && (n.reloadNode.disabled = !e,
                      t !== undefined && (n.reloadNode.textContent = t))
                  },
                  clearChallenge: function () {
                    let e = TCaptcha;
                    e.node && (e.challengeNode.value = "",
                      e.respNode.value = "",
                      e.fgNode.style.backgroundImage = "",
                      e.bgNode.style.backgroundImage = "",
                      e.toggleSlider(!1))
                  },
                  toggleSlider: function (e) {
                    TCaptcha.sliderNode.style.visibility = e ? "" : "hidden"
                  },
                  onSliderInput: function () {
                    var e = -Math.floor(+this.value / 100 * this.twisterDelta);
                    TCaptcha.bgNode.style.backgroundPositionX = e + "px"
                  },
                  buildFromJson: function (e) {
                    let t = TCaptcha;
                    if (t.node) {
                      if (e.error)
                        return console.log(e.error),
                          void (TCaptcha.errorCb && TCaptcha.errorCb.call(null, e.error));
                      t.imgCntNode.style.width = e.img_width + "px",
                        t.imgCntNode.style.height = e.img_height + "px",
                        t.challengeNode.value = e.challenge,
                        t.toggleReloadBtn(!1, "Get Captcha"),
                        t.reloadTimeout = setTimeout(t.toggleReloadBtn, 1e3 * e.cd, !0),
                        t.expireTimeout = setTimeout(t.clearChallenge, 1e3 * e.ttl - 3e3),
                        e.bg_width ? t.buildTwister(e) : t.buildStatic(e)
                    }
                  },
                  buildTwister: function (e) {
                    let t = TCaptcha;
                    t.fgNode.style.backgroundImage = "url(data:image/png;base64," + e.img + ")",
                      t.bgNode.style.backgroundImage = "url(data:image/png;base64," + e.bg + ")",
                      t.bgNode.style.backgroundPositionX = "0px",
                      t.toggleSlider(!0),
                      t.sliderNode.value = 0,
                      t.sliderNode.twisterDelta = e.bg_width - e.img_width,
                      t.sliderNode.focus()
                  },
                  buildStatic: function (e) {
                    let t = TCaptcha;
                    t.toggleSlider(!1),
                      t.fgNode.style.backgroundImage = "url(data:image/png;base64," + e.img + ")",
                      t.bgNode.style.backgroundImage = ""
                  }
                }
              </script>
            </head>

            <body>
              <div id="t-root">
              </div>
            </body>

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
