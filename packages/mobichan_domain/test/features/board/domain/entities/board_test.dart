import 'package:flutter_test/flutter_test.dart';
import 'package:mobichan_domain/mobichan_domain.dart';

void main() {
  group('Board', () {
    group('fullTitle', () {
      test('should return the right value given a board', () {
        const board = Board(board: 'g', title: 'Technology', wsBoard: 1);
        final result = board.fullTitle;
        expect(result, '/g/ - Technology');
      });
    });

    group('initial', () {
      test('should return Technology as the default board', () {
        const expectedBoard = Board(
          board: 'g',
          title: 'Technology',
          wsBoard: 1,
        );
        final result = Board.initial;
        expect(result, expectedBoard);
      });
    });

    group('compareTo', () {
      test('should sort boards by alphabetical order', () {
        const animeBoard = Board(
          board: 'a',
          title: 'Anime & Manga',
          wsBoard: 1,
        );
        const technologyBoard = Board(
          board: 'g',
          title: 'Technology',
          wsBoard: 1,
        );
        final result = technologyBoard.compareTo(animeBoard) > 0;
        expect(result, true);
      });
    });
  });
}
