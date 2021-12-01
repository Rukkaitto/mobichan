import 'package:flutter_test/flutter_test.dart';
import 'package:mobichan_domain/mobichan_domain.dart';

void main() {
  group('Board', () {
    const tTechnologyBoard = Board(
      board: 'g',
      title: 'Technology',
      wsBoard: 1,
    );
    const tAnimeBoard = Board(
      board: 'a',
      title: 'Anime & Manga',
      wsBoard: 1,
    );

    group('fullTitle', () {
      test('should return the right value given a board', () {
        final result = tTechnologyBoard.fullTitle;
        expect(result, '/g/ - Technology');
      });
    });

    group('initial', () {
      test('should return /g/ as the default board', () {
        final result = Board.initial;
        expect(result, tTechnologyBoard);
      });
    });

    group('compareTo', () {
      test('should sort boards by alphabetical order', () {
        final result = tTechnologyBoard.compareTo(tAnimeBoard) > 0;
        expect(result, true);
      });
    });

    group('props', () {
      test('should return the board code and title', () {
        final props = tTechnologyBoard.props;
        expect(props, [tTechnologyBoard.board, tTechnologyBoard.title]);
      });
    });
  });
}
