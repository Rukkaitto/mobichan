import 'package:mobichan/features/board/data/models/board_model.dart';

abstract class BoardLocalDataSource {
  /// Gets the cached [BoardModel] which was gotten the last time
  ///
  /// Throws [NoLocalDataException] if no cached data is present.
  Future<BoardModel> getLastBoard();

  Future<void> cacheBoard(BoardModel boardToCache);
}
