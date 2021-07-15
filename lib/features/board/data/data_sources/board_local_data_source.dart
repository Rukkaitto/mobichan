import 'dart:convert';

import 'package:mobichan/core/error/exception.dart';
import 'package:mobichan/features/board/data/models/board_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class BoardLocalDataSource {
  /// Gets the cached [BoardModel] which was gotten the last time
  ///
  /// Throws [NoLocalDataException] if no cached data is present.
  Future<BoardModel> getLastBoard();

  Future<void> cacheBoard(BoardModel boardToCache);
}

const CACHED_BOARD = 'CACHED_BOARD';

class BoardLocalDataSourceImpl implements BoardLocalDataSource {
  final SharedPreferences sharedPreferences;

  BoardLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<BoardModel> getLastBoard() {
    final jsonString = sharedPreferences.getString(CACHED_BOARD);
    if (jsonString != null) {
      return Future.value(BoardModel.fromJson(jsonDecode(jsonString)));
    } else {
      throw CacheException();
    }
  }

  @override
  Future<void> cacheBoard(BoardModel boardToCache) {
    return sharedPreferences.setString(
      CACHED_BOARD,
      jsonEncode(boardToCache.toJson()),
    );
  }
}
