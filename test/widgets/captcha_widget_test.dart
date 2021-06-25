import 'package:flutter_test/flutter_test.dart';
import 'package:mobichan/widgets/captcha_widget.dart';

void main() {
  testWidgets('CaptchaWidget loads', (WidgetTester tester) async {
    bool hasError = false;
    await tester.pumpWidget(
      CaptchaWidget(
        onValidate: (response) {},
        onError: () {
          hasError = true;
          print(hasError ? "has error" : "has no error");
        },
      ),
    );

    await tester.pumpAndSettle(Duration(seconds: 5));
    expect(hasError, false);
  });
}
