import 'package:mobichan_data/mobichan_data.dart';
import 'package:sqflite/sqflite.dart';

abstract class PostLocalDatasource {
  Future<List<PostModel>> addThreadToHistory(
      PostModel thread, BoardModel board);

  Future<List<PostModel>> getHistory();

  Future<void> insertPost(String table, BoardModel board, PostModel post);

  Future<void> insertPosts(
      String table, BoardModel board, List<PostModel> posts);

  Future<List<PostModel>> getCachedReplies(PostModel thread);

  Future<List<PostModel>> getCachedThreads(
      {required BoardModel board, required SortModel sort});
}

class PostLocalDatasourceImpl implements PostLocalDatasource {
  final String apiUrl = 'https://a.4cdn.org';
  final String threadHistoryKey = 'thread_history';

  final Database database;

  PostLocalDatasourceImpl({
    required this.database,
  });

  @override
  Future<List<PostModel>> addThreadToHistory(
    PostModel thread,
    BoardModel board,
  ) async {
    Map<String, dynamic> threadJson = thread.toJson();
    threadJson['board_id'] = board.board;
    threadJson['board_title'] = board.title;
    threadJson['board_ws'] = board.wsBoard;
    PostModel newThread = PostModel.fromJson(threadJson);

    final history = await _getCachedPosts('history');

    if (history.contains(newThread)) {
      history.remove(newThread);
    }
    history.add(newThread);

    await insertPosts('history', board, history);
    return history;
  }

  @override
  Future<List<PostModel>> getHistory() async {
    final history = await _getCachedPosts('history');
    return history.reversed.toList();
  }

  @override
  Future<void> insertPost(
      String table, BoardModel board, PostModel post) async {
    final postJson = post.toJson();
    postJson['board_id'] = post.boardId ?? board.board;
    postJson['board_title'] = post.boardTitle ?? board.title;
    postJson['board_ws'] = post.boardWs ?? board.wsBoard;

    await database.insert(
      table,
      postJson,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> insertPosts(
      String table, BoardModel board, List<PostModel> posts) async {
    final batch = database.batch();
    for (PostModel post in posts) {
      final postJson = post.toJson();
      postJson['board_id'] = board.board;
      postJson['board_title'] = board.title;
      postJson['board_ws'] = board.wsBoard;

      batch.insert(
        table,
        postJson,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);
  }

  @override
  Future<List<PostModel>> getCachedReplies(PostModel thread) async {
    final posts = await _getCachedPosts('posts');
    return posts.where((post) => post.resto == thread.no).toList();
  }

  @override
  Future<List<PostModel>> getCachedThreads({
    required BoardModel board,
    required SortModel sort,
  }) async {
    final posts = await _getCachedPosts('posts');
    return posts
        .where((post) => post.resto == 0 && post.boardId == board.board)
        .toList();
  }

  Future<List<PostModel>> _getCachedPosts(String table) async {
    final maps = await database.query(table);
    return List.generate(maps.length, (index) {
      return PostModel.fromJson(maps[index]);
    });
  }
}
