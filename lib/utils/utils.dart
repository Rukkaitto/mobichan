import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:mobichan_data/mobichan_data.dart';
import 'package:mobichan_domain/mobichan_domain.dart';
import 'package:mobichan/constants.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Utils {
  // TODO: make a sort repository and move this in there
  static saveLastSortingOrder(Sort sorting) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(LAST_SORTING_ORDER, sorting.toString());
  }

  // TODO: make a sort repository and move this in there
  static Future<Sort> getLastSortingOrder() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? lastSortingOrderString = prefs.getString(LAST_SORTING_ORDER);
    if (lastSortingOrderString != null) {
      return Utils.getSortFromString(lastSortingOrderString)!;
    }
    return Sort.byBumpOrder;
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

  static Future<bool> isThreadInHistory(Post thread) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> history;
    if (prefs.containsKey(THREAD_HISTORY)) {
      history = prefs.getStringList(THREAD_HISTORY)!;
    } else {
      history = List.empty(growable: true);
    }
    return history.map((e) {
      Post pastThread = PostModel.fromJson(jsonDecode(e));
      return pastThread.no;
    }).contains(thread.no);
  }

  static void addThreadToHistory(PostModel thread, Board board) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> threadJson = thread.toJson();
    threadJson['board'] = board.toString();
    String newThread = jsonEncode(threadJson);

    List<String> history;
    if (prefs.containsKey(THREAD_HISTORY)) {
      history = prefs.getStringList(THREAD_HISTORY)!;
    } else {
      history = List.empty(growable: true);
    }
    if (await isThreadInHistory(thread)) {
      history.remove(newThread);
    }
    history.add(newThread);
    prefs.setStringList(THREAD_HISTORY, history);
  }

  static List<Post> getReplies(List<Post> posts, Post post) {
    List<Post> replies = List.empty(growable: true);
    posts.forEach((otherPost) {
      final regExp = RegExp(r'(?<=href="#p)\d+(?=")');
      final matches = regExp
          .allMatches(otherPost.com ?? '')
          .map((match) => int.parse(match.group(0) ?? ""));

      // if another post quotes this post
      if (matches.contains(post.no)) {
        // add other post to replies list
        replies.add(otherPost);
      }
    });
    return replies;
  }

  static List<int> replyingTo(List<Post> posts, Post post) {
    final regExp = RegExp(r'(?<=href="#p)\d+(?=")');
    final matches = regExp
        .allMatches(post.com ?? '')
        .map((match) => int.parse(match.group(0) ?? ""))
        .toList();
    return matches;
  }

  static bool isRootPost(Post post) {
    final regExp = RegExp(r'(?<=href="#p)\d+(?=")');
    final matches = regExp
        .allMatches(post.com ?? '')
        .map((match) => int.parse(match.group(0) ?? ""))
        .toList();
    return matches.isEmpty;
  }

  static Post getQuotedPost(List<Post> posts, int no) {
    return posts.firstWhere((post) => post.no == no);
  }

  static Sort? getSortFromString(String sortAsString) {
    for (Sort element in Sort.values) {
      if (element.toString() == sortAsString) {
        return element;
      }
    }
    return null;
  }

  static SnackBar buildSnackBar(
      BuildContext context, String text, Color color) {
    return SnackBar(
      backgroundColor: color,
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      content: Text(
        text,
        style: snackbarTextStyle(context),
      ),
    );
  }
}
