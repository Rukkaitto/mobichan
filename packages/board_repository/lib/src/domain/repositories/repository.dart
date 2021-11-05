import 'package:board_repository/board_repository.dart';

abstract class BoardRepository {
  Future<List<Board>> getBoards();

  Future<List<Board>> getFavoriteBoards();

  Future<bool> isBoardInFavorites(Board board);

  Future<void> addBoardToFavorites(Board board);

  Future<void> removeBoardFromFavorites(Board board);
}
