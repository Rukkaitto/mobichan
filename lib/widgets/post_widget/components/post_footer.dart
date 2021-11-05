import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mobichan/classes/entities/post.dart';
import 'package:mobichan/pages/replies_page.dart';

import '../../../constants.dart';

class PostFooter extends StatelessWidget {
  const PostFooter({
    Key? key,
    required this.postReplies,
    required this.threadReplies,
    required this.board,
  }) : super(key: key);

  final List<Post> postReplies;
  final List<Post> threadReplies;
  final String board;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        InkWell(
          child: Text(
            'reply'.plural(postReplies.length),
            style: postNoTextStyle(context),
          ),
          onTap: () {
            Navigator.of(context).push(
              PageRouteBuilder(
                pageBuilder: (context, _, __) => RepliesPage(
                  postReplies,
                  board: board,
                  threadReplies: threadReplies,
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
