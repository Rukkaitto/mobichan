import 'package:flutter_test/flutter_test.dart';
import 'package:mobichan_domain/mobichan_domain.dart';

void main() {
  group('CaptchaChallenge', () {
    test('should have a constructor', () {
      expect(
          CaptchaChallenge(
            challenge: '',
            expireTime: 789789,
            refreshTime: 789789,
            foregroundImage: 'foregroundImage',
            foregroundImageWidth: 637,
            foregroundImageHeight: 783,
            backgroundImage: 'backgroundImage',
            backgroundImageWidth: 789,
          ),
          isNotNull);
    });
  });
}
