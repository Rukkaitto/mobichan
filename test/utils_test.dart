import 'package:flutter_test/flutter_test.dart';
import 'package:mobichan/classes/shared_preferences/board_shared_prefs.dart';
import 'package:mobichan/utils/utils.dart';

void main() {
  test('should save the last visited board in shared preferences', () async {
    await Utils.saveLastVisitedBoard(board: 'a', title: 'Anime & Manga');
    BoardSharedPrefs boardSharedPrefs = await Utils.getLastVisitedBoard();

    expect(boardSharedPrefs.board == 'a', true);
    expect(boardSharedPrefs.title == 'Anime & Manga', true);
  });
}
