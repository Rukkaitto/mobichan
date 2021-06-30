import 'dart:io';

import 'package:flutter/services.dart';
import 'package:mobichan/classes/shared_preferences/board_shared_prefs.dart';
import 'package:mobichan/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

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

  static bool isLocalFilePath(String path) {
  Uri uri = Uri.parse(path);
  return !uri.scheme.contains('http');
}

    static Future<bool?> saveImage(String path, {String? albumName}) async {
    MethodChannel channel = const MethodChannel('gallery_saver');
    File? tempFile;
    if (!isLocalFilePath(path)) {
      tempFile = await _downloadFile(path);
      path = tempFile.path;
    }

    bool? result = await channel.invokeMethod(
      'saveImage',
      <String, dynamic>{'path': path, 'albumName': albumName},
    );
    if (tempFile != null) {
      tempFile.delete();
    }

    return result;
  }

  static Future<File> _downloadFile(String url) async {
    print(url);
    http.Client _client = new http.Client();
    var req = await _client.get(Uri.parse(url));
    var bytes = req.bodyBytes;
    String dir = (await getTemporaryDirectory()).path;
    File file = new File('$dir/${basename(url)}');
    await file.writeAsBytes(bytes);
    print('File size:${await file.length()}');
    print(file.path);
    return file;
  }
}
