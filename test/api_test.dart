import 'package:flutter_test/flutter_test.dart';
import 'package:mobichan/api/api.dart';
import 'package:mobichan/classes/models/board.dart';
import 'package:mobichan/classes/models/post.dart';

void main() {
  test('should fetch a list of boards', () async {
    Future<List<Board>> boardsFuture = fetchBoards();
    await boardsFuture.then((boards) {
      expect(boards.isEmpty, false);

      Board board = boards.firstWhere((element) => element.board == 'a');
      expect(board.title, "Anime & Manga");
    });
  });

  test('should fetch all the OPs in a board', () async {
    Future<List<Post>> postsFuture = fetchOPs(board: 'a');
    await postsFuture.then((ops) {
      expect(ops.isEmpty, false);

      ops.forEach((op) {
        expect(op.no > 0, true);
        expect(op.resto == 0, true);
      });
    });
  });

  test('should fetch a list of posts in a thread', () async {
    Future<List<Post>> postsFuture = fetchPosts(board: 'po', thread: 570368);
    await postsFuture.then((posts) {
      expect(posts.isEmpty, false);

      posts.forEach((post) {
        expect(post.no > 0, true);
        expect(post.com == '', false);
      });
    });
  });
}
