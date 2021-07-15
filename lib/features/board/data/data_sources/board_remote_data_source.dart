import 'package:mobichan/features/board/data/models/board_model.dart';

abstract class BoardRemoteDataSource {
  /// Calls the https://a.4cdn.org/boards.json endpoint.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<List<BoardModel>> getAllBoards();

  /// Calls the https://a.4cdn.org/boards.json endpoint
  /// and returns a board model depending on the code argument.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<BoardModel> getBoard(String code);
}
