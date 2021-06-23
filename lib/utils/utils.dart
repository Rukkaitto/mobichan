import 'package:mobichan/classes/shared_preferences/board_shared_prefs.dart';
import 'package:mobichan/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Utils {
  static getLastVisitedBoard() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String lastVisitedBoard = prefs.getString(LAST_VISITED_BOARD) ?? '';
    String lastVisitedBoardTitle =
        prefs.getString(LAST_VISITED_BOARD_TITLE) ?? '';

    BoardSharedPrefs boardSharedPrefs =
        BoardSharedPrefs(board: lastVisitedBoard, title: lastVisitedBoardTitle);

    return boardSharedPrefs;
  }

  static saveLastVisitedBoard(
      {required String board, required String title}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(LAST_VISITED_BOARD, board);
    await prefs.setString(LAST_VISITED_BOARD_TITLE, title);
  }
}
