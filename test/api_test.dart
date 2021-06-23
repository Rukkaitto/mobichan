import 'package:flutter_test/flutter_test.dart';
import 'package:mobichan/api/api.dart';
import 'package:mobichan/classes/models/board.dart';

void main() {
  test('should fetch a list of boards', () async {
    Future<List<Board>> boardsFuture = fetchBoards();
    await boardsFuture.then((boards) {
      expect(boards.isEmpty, false);

      Board board = boards.firstWhere((element) => element.board == 'a');
      expect(board.title, "Anime & Manga");
    });
  });
}
