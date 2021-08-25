import 'package:html/dom.dart' show Element;
import 'package:html/parser.dart' show parse;
import 'package:html_unescape/html_unescape.dart';

extension StringExtension on String {
  String? get errorMsg {
    var document = parse(this);
    Element? errMsg = document.getElementById('errmsg');
    if (errMsg != null) {
      return errMsg.innerHtml;
    }
  }

  String get removeHtmlTags {
    RegExp regExp = RegExp(
      r"<[^>]*>",
      multiLine: true,
      caseSensitive: true,
    );
    return this.replaceAll(regExp, '');
  }

  String get unescapeHtml {
    HtmlUnescape unescape = HtmlUnescape();
    return unescape.convert(this);
  }

  String get removeWbr {
    return this.replaceAll('<wbr>', '');
  }

  String get replaceWbrWithNewline {
    return this.replaceAll('<wbr>', ' \n');
  }

  String get replaceBrWithSpace {
    return this.replaceAll('<br>', ' ');
  }

  String get replaceBrWithNewline {
    return this.replaceAll('<br>', ' \n');
  }

  bool parseBool() {
    return this.toLowerCase() == 'true';
  }
}
