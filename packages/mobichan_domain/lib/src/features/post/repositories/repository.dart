import '../entities/entities.dart';

abstract class PostRepository {
  Future<List<Post>> getPosts({required String board, required int thread});

  Future<List<Post>> getThreads({required String board, Sort? sorting});

  Future<String> postThread({
    required String board,
    required String captchaChallenge,
    required String captchaResponse,
    required String com,
    String? name,
    String? subject,
    String? filePath,
  });

  Future<String> postReply({
    required String board,
    required String captchaChallenge,
    required String captchaResponse,
    required int resto,
    String? name,
    String? com,
    String? filePath,
  });

  Future<void> addThreadToHistory(Post thread, String board);
}
