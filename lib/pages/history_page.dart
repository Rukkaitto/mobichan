import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobichan/classes/arguments/thread_page_arguments.dart';
import 'package:mobichan/classes/models/post.dart';
import 'package:mobichan/constants.dart';
import 'package:mobichan/extensions/string_extension.dart';
import 'package:mobichan/pages/thread_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HistoryPage extends StatelessWidget {
  static const routeName = '/history';
  const HistoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('history').tr(),
      ),
      body: FutureBuilder(
        future: SharedPreferences.getInstance(),
        builder:
            (BuildContext context, AsyncSnapshot<SharedPreferences> snapshot) {
          if (snapshot.hasData) {
            SharedPreferences prefs = snapshot.data!;
            if (prefs.containsKey(THREAD_HISTORY)) {
              List<String> history =
                  prefs.getStringList(THREAD_HISTORY)!.reversed.toList();
              return ListView.builder(
                itemExtent: 50,
                itemCount: history.length,
                itemBuilder: (context, index) {
                  Post thread = Post.fromJson(jsonDecode(history[index]));
                  return ListTile(
                    leading: Text(
                      '/${thread.board!}/',
                      overflow: TextOverflow.ellipsis,
                    ),
                    dense: true,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ThreadPage(
                            args: ThreadPageArguments(
                              board: thread.board!,
                              thread: thread.no,
                              title: thread.sub ??
                                  thread.com?.replaceBrWithSpace.removeHtmlTags
                                      .unescapeHtml ??
                                  '',
                            ),
                          ),
                        ),
                      );
                    },
                    title: Text(thread.sub ??
                        thread.com?.replaceBrWithSpace.removeHtmlTags
                            .unescapeHtml ??
                        ''),
                  );
                },
              );
            }
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Could not retrieve shared preferences.'),
            );
          }
          return Container();
        },
      ),
    );
  }
}
