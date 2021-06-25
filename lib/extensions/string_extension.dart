import 'package:html/dom.dart' show Element;
import 'package:html/parser.dart' show parse;

extension StringExtension on String {
  String? get errorMsg {
    var document = parse(this);
    Element? errMsg = document.getElementById('errmsg');
    if (errMsg != null) {
      return errMsg.innerHtml;
    }
  }
}
