import 'package:flutter_test/flutter_test.dart';
import 'package:mobichan_domain/mobichan_domain.dart';

void main() {
  group('initial', () {
    test('should return sort by bump order', () {
      final sort = Sort.initial;
      expect(sort.order, Order.byBump);
    });
  });
}
