import 'package:mobichan_domain/mobichan_domain.dart';
import 'package:mobichan_data/mobichan_data.dart';

class PostRepositoryImpl implements PostRepository {
  final PostLocalDatasource localDatasource;
  final PostRemoteDatasource remoteDatasource;

  PostRepositoryImpl({
    required this.localDatasource,
    required this.remoteDatasource,
  });

  @override
  Future<void> addThreadToHistory(Post thread, Board board) async {
    return localDatasource.addThreadToHistory(
      PostModel.fromEntity(thread),
      BoardModel.fromEntity(board),
    );
  }

  @override
  Future<List<Post>> getPosts(
      {required Board board, required Post thread}) async {
    return remoteDatasource.getPosts(
      board: BoardModel.fromEntity(board),
      thread: PostModel.fromEntity(thread),
    );
  }

  @override
  Future<List<Post>> getThreads({required Board board, Sort? sorting}) {
    return remoteDatasource.getThreads(
      board: BoardModel.fromEntity(board),
      sorting: sorting,
    );
  }

  @override
  Future<String> postReply({
    required Board board,
    required String captchaChallenge,
    required String captchaResponse,
    required Post resto,
    String? name,
    String? com,
    String? filePath,
  }) {
    return remoteDatasource.postReply(
      board: BoardModel.fromEntity(board),
      captchaChallenge: captchaChallenge,
      captchaResponse: captchaResponse,
      resto: PostModel.fromEntity(resto),
      name: name,
      com: com,
      filePath: filePath,
    );
  }

  @override
  Future<String> postThread(
      {required Board board,
      required String captchaChallenge,
      required String captchaResponse,
      required String com,
      String? name,
      String? subject,
      String? filePath}) {
    return remoteDatasource.postThread(
      board: BoardModel.fromEntity(board),
      captchaChallenge: captchaChallenge,
      captchaResponse: captchaResponse,
      com: com,
      name: name,
      subject: subject,
      filePath: filePath,
    );
  }

  @override
  Future<List<Post>> getHistory() async {
    return localDatasource.getHistory();
  }
}
