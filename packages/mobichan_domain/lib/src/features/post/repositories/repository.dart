import 'package:mobichan_domain/mobichan_domain.dart';

abstract class PostRepository {
  Future<List<Post>> getPosts({required Board board, required Post thread});

  Future<List<Post>> getThreads({required Board board, required Sort sort});

  Future<Post> postThread({
    required Board board,
    required String captchaChallenge,
    required String captchaResponse,
    required Post post,
    String? filePath,
  });

  Future<Post> postReply({
    required Board board,
    required String captchaChallenge,
    required String captchaResponse,
    required Post post,
    required Post resto,
    String? filePath,
  });

  Future<List<Post>> addThreadToHistory(Post thread, Board board);

  Future<List<Post>> getHistory();

  Future<void> insertPost(Board board, Post post);

  Future<void> insertUserPost(Post post);

  Future<List<Post>> getUserPosts();
}
