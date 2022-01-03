import 'package:mobichan_domain/mobichan_domain.dart';
import 'package:mobichan_data/mobichan_data.dart';

class PostRepositoryImpl implements PostRepository {
  final PostLocalDatasource localDatasource;
  final PostRemoteDatasource remoteDatasource;
  final NetworkInfo networkInfo;

  PostRepositoryImpl({
    required this.localDatasource,
    required this.remoteDatasource,
    required this.networkInfo,
  });

  @override
  Future<List<Post>> addThreadToHistory(Post thread, Board board) async {
    return localDatasource.addThreadToHistory(
      PostModel.fromEntity(thread),
      BoardModel.fromEntity(board),
    );
  }

  @override
  Future<List<Post>> getPosts({
    required Board board,
    required Post thread,
  }) async {
    try {
      return remoteDatasource.getPosts(
        board: BoardModel.fromEntity(board),
        thread: PostModel.fromEntity(thread),
      );
    } catch (e) {
      final posts = await localDatasource.getCachedPosts(
        PostModel.fromEntity(thread),
      );
      if (posts.isNotEmpty) {
        return posts;
      }
      rethrow;
    }
  }

  @override
  Future<List<Post>> getThreads(
      {required Board board, required Sort sort}) async {
    try {
      return remoteDatasource.getThreads(
        board: BoardModel.fromEntity(board),
        sort: sort,
      );
    } catch (e) {
      final threads = await localDatasource.getCachedThreads(
        BoardModel.fromEntity(board),
      );
      if (threads.isNotEmpty) {
        return threads;
      }
      rethrow;
    }
  }

  @override
  Future<void> postReply({
    required Board board,
    required String captchaChallenge,
    required String captchaResponse,
    required Post resto,
    required Post post,
    String? filePath,
  }) {
    return remoteDatasource.postReply(
      board: BoardModel.fromEntity(board),
      captchaChallenge: captchaChallenge,
      captchaResponse: captchaResponse,
      resto: PostModel.fromEntity(resto),
      post: PostModel.fromEntity(post),
      filePath: filePath,
    );
  }

  @override
  Future<void> postThread({
    required Board board,
    required String captchaChallenge,
    required String captchaResponse,
    required Post post,
    String? filePath,
  }) {
    return remoteDatasource.postThread(
      board: BoardModel.fromEntity(board),
      captchaChallenge: captchaChallenge,
      captchaResponse: captchaResponse,
      post: PostModel.fromEntity(post),
      filePath: filePath,
    );
  }

  @override
  Future<List<Post>> getHistory() async {
    return localDatasource.getHistory();
  }

  @override
  Future<void> insertPost(Board board, Post post) {
    return localDatasource.insertPost(
      BoardModel.fromEntity(board),
      PostModel.fromEntity(post),
    );
  }
}
