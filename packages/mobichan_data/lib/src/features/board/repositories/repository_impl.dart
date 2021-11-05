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
    return localDataSource.addBoardToFavorites(BoardModel.fromEntity(board));
  }

  @override
  Future<List<Board>> getBoards() async {
    return remoteDatasource.getBoards();
  }

  @override
  Future<List<Board>> getFavoriteBoards() async {
    return localDataSource.getFavoriteBoards();
  }

  @override
  Future<bool> isBoardInFavorites(Board board) async {
    return localDataSource.isBoardInFavorites(BoardModel.fromEntity(board));
  }

  @override
  Future<void> removeBoardFromFavorites(Board board) async {
    return localDataSource
        .removeBoardFromFavorites(BoardModel.fromEntity(board));
  }

  @override
  Future<Board> getLastVisitedBoard() async {
    return localDataSource.getLastVisitedBoard();
  }

  @override
  Future<void> saveLastVisitedBoard(Board board) async {
    return localDataSource.saveLastVisitedBoard(BoardModel.fromEntity(board));
  }
}
