import 'package:mobichan_domain/mobichan_domain.dart';

abstract class PostRepository {
  Future<List<Post>> getPosts({required Board board, required Post thread});

  Future<List<Post>> getThreads({required Board board, required Sort sort});

  Future<String> postThread({
    required Board board,
    required String captchaChallenge,
    required String captchaResponse,
    required String com,
    String? name,
    String? subject,
    String? filePath,
  });

  Future<String> postReply({
    required Board board,
    required String captchaChallenge,
    required String captchaResponse,
    required Post resto,
    String? name,
    String? com,
    String? filePath,
  });

  Future<void> addThreadToHistory(Post thread, Board board);

  Future<List<Post>> getHistory();
}
