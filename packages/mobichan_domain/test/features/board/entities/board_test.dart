import 'package:flutter_test/flutter_test.dart';
import 'package:mobichan_domain/mobichan_domain.dart';

void main() {
  group('Board', () {
    const technologyBoard = Board(
      board: 'g',
      title: 'Technology',
      wsBoard: 1,
    );
    const animeBoard = Board(
      board: 'a',
      title: 'Anime & Manga',
      wsBoard: 1,
    );

    group('fullTitle', () {
      test('should return the right value given a board', () {
        final result = technologyBoard.fullTitle;
        expect(result, '/g/ - Technology');
      });
    });

    group('initial', () {
      test('should return /g/ as the default board', () {
        final result = Board.initial;
        expect(result, technologyBoard);
      });
    });

    group('compareTo', () {
      test('should sort boards by alphabetical order', () {
        final result = technologyBoard.compareTo(animeBoard) > 0;
        expect(result, true);
      });
    });
  });
}
