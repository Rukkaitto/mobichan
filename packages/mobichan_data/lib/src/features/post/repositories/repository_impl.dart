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
      return await remoteDatasource.getPosts(
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
  Future<List<Post>> getThreads({
    required Board board,
    required Sort sort,
  }) async {
    try {
      return await remoteDatasource.getThreads(
        board: BoardModel.fromEntity(board),
        sort: SortModel.fromEntity(sort),
      );
    } catch (e) {
      final threads = await localDatasource.getCachedThreads(
        board: BoardModel.fromEntity(board),
        sort: SortModel.fromEntity(sort),
      );
      if (threads.isNotEmpty) {
        return threads;
      }
      rethrow;
    }
  }

  @override
  Future<Post> postReply({
    required Board board,
    required String captchaChallenge,
    required String captchaResponse,
    required Post resto,
    required Post post,
    String? filePath,
  }) async {
    final reply = await remoteDatasource.postReply(
      board: BoardModel.fromEntity(board),
      captchaChallenge: captchaChallenge,
      captchaResponse: captchaResponse,
      resto: PostModel.fromEntity(resto),
      post: PostModel.fromEntity(post),
      filePath: filePath,
    );
    await remoteDatasource.saveToFirestore(
      post: PostModel.fromEntity(reply),
      resto: PostModel.fromEntity(resto),
    );
    return reply;
  }

  @override
  Future<Post> postThread({
    required Board board,
    required String captchaChallenge,
    required String captchaResponse,
    required Post post,
    String? filePath,
  }) async {
    final thread = await remoteDatasource.postThread(
      board: BoardModel.fromEntity(board),
      captchaChallenge: captchaChallenge,
      captchaResponse: captchaResponse,
      post: PostModel.fromEntity(post),
      filePath: filePath,
    );
    await remoteDatasource.saveToFirestore(
      post: PostModel.fromEntity(thread),
      resto: PostModel(no: 0),
    );
    return thread;
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

  @override
  Future<List<Post>> getUserPosts() {
    return localDatasource.getUserPosts();
  }

  @override
  Future<void> insertUserPost(Post post) {
    return localDatasource.insertUserPost(
      PostModel.fromEntity(post),
    );
  }
}
