import '../entities/entities.dart';

abstract class BoardRepository {
  Future<List<Board>> getBoards();

  Future<List<Board>> getFavoriteBoards();

  Future<bool> isBoardInFavorites(Board board);

  Future<void> addBoardToFavorites(Board board);

  Future<void> removeBoardFromFavorites(Board board);

  Future<Board> getLastVisitedBoard();

  Future<void> saveLastVisitedBoard(Board board);
}
