import 'package:mobichan_domain/mobichan_domain.dart';
import '../models/models.dart';
import '../datasources/datasources.dart';

class PostRepositoryImpl implements PostRepository {
  final PostLocalDatasource localDatasource;
  final PostRemoteDatasource remoteDatasource;

  PostRepositoryImpl({
    required this.localDatasource,
    required this.remoteDatasource,
  });

  @override
  Future<void> addThreadToHistory(Post thread, String board) async {
    return localDatasource.addThreadToHistory(
        PostModel.fromEntity(thread), board);
  }

  @override
  Future<List<Post>> getPosts(
      {required String board, required int thread}) async {
    return remoteDatasource.getPosts(
      board: board,
      thread: thread,
    );
  }

  @override
  Future<List<Post>> getThreads({required String board, Sort? sorting}) {
    return remoteDatasource.getThreads(board: board, sorting: sorting);
  }

  @override
  Future<String> postReply(
      {required String board,
      required String captchaChallenge,
      required String captchaResponse,
      required int resto,
      String? name,
      String? com,
      String? filePath}) {
    return remoteDatasource.postReply(
      board: board,
      captchaChallenge: captchaChallenge,
      captchaResponse: captchaResponse,
      resto: resto,
      name: name,
      com: com,
      filePath: filePath,
    );
  }

  @override
  Future<String> postThread(
      {required String board,
      required String captchaChallenge,
      required String captchaResponse,
      required String com,
      String? name,
      String? subject,
      String? filePath}) {
    return remoteDatasource.postThread(
      board: board,
      captchaChallenge: captchaChallenge,
      captchaResponse: captchaResponse,
      com: com,
      name: name,
      subject: subject,
      filePath: filePath,
    );
  }
}
