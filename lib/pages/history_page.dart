import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobichan/classes/arguments/thread_page_arguments.dart';
import 'package:mobichan_data/mobichan_data.dart';
import 'package:mobichan_domain/mobichan_domain.dart';
import 'package:mobichan/constants.dart';
import 'package:mobichan/extensions/string_extension.dart';
import 'package:mobichan/localization.dart';
import 'package:mobichan/pages/thread_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HistoryPage extends StatelessWidget {
  static const routeName = '/history';
  const HistoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(history).tr(),
      ),
      body: FutureBuilder(
        future: context.read<PostRepository>().getHistory(),
        builder: (BuildContext context, AsyncSnapshot<List<Post>> snapshot) {
          if (snapshot.hasData) {
            List<Post> history = snapshot.data!;
            return ListView.builder(
              itemExtent: 50,
              itemCount: history.length,
              itemBuilder: (context, index) {
                Post thread = history[index];
                return ListTile(
                  leading: Text(
                    '/${thread.board!.board}/',
                    overflow: TextOverflow.ellipsis,
                  ),
                  title: Text(thread.sub ??
                      thread.com?.replaceBrWithSpace.removeHtmlTags
                          .unescapeHtml ??
                      ''),
                  dense: true,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ThreadPage(
                          args: ThreadPageArguments(
                            thread: thread,
                            board: thread.board!,
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            );
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
