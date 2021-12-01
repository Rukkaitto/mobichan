import 'package:flutter_test/flutter_test.dart';
import 'package:mobichan_domain/mobichan_domain.dart';

void main() {
  group('Release', () {
    test('should have a constructor', () {
      expect(
          Release(
            browserDownloadUrl: 'browserDownloadUrl',
            tagName: 'tagName',
            name: 'name',
            body: 'body',
            size: 789,
          ),
          isNotNull);
    });
  });
}
