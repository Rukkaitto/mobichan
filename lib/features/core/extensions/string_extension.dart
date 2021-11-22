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
    return replaceBrWithNewline.replaceAll(regExp, '').unescapeHtml;
  }

  String get unescapeHtml {
    HtmlUnescape unescape = HtmlUnescape();
    return unescape.convert(this);
  }

  String get removeWbr {
    return replaceAll('<wbr>', '');
  }

  String get replaceWbrWithNewline {
    return replaceAll('<wbr>', ' \n');
  }

  String get replaceBrWithSpace {
    return replaceAll('<br>', ' ');
  }

  String get replaceBrWithNewline {
    return replaceAll('<br>', ' \n');
  }

  bool parseBool() {
    return toLowerCase() == 'true';
  }
}
