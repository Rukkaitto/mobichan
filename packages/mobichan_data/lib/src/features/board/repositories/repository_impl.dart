import '../datasources/datasources.dart';
import '../models/models.dart';
import 'package:mobichan_domain/mobichan_domain.dart';

class BoardRepositoryImpl extends BoardRepository {
  final BoardLocalDatasource localDataSource;
  final BoardRemoteDatasource remoteDatasource;

  BoardRepositoryImpl({
    required this.localDataSource,
    required this.remoteDatasource,
  });

  @override
  Future<void> addBoardToFavorites(Board board) async {
    return localDataSource.addBoardToFavorites(board as BoardModel);
  }

  @override
  Future<List<Board>> getBoards() {
    return remoteDatasource.getBoards();
  }

  @override
  Future<List<Board>> getFavoriteBoards() {
    return localDataSource.getFavoriteBoards();
  }

  @override
  Future<bool> isBoardInFavorites(Board board) {
    return localDataSource.isBoardInFavorites(BoardModel.fromEntity(board));
  }

  @override
  Future<void> removeBoardFromFavorites(Board board) {
    return localDataSource
        .removeBoardFromFavorites(BoardModel.fromEntity(board));
  }
}
