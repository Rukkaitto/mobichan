import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobichan/features/post/post.dart';
import 'package:mobichan_domain/mobichan_domain.dart';

import 'replies_page.dart';

class RepliesPageArguments {
  final Board board;
  final List<Post> postReplies;
  final List<Post> threadReplies;

  RepliesPageArguments({
    required this.board,
    required this.postReplies,
    required this.threadReplies,
  });
}

class RepliesPage extends StatelessWidget {
  static const routeName = '/replies';

  const RepliesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as RepliesPageArguments;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'reply'.plural(args.postReplies.length),
        ),
        actions: [
          IconButton(
            onPressed: () => handleClose(context),
            icon: const Icon(Icons.close_rounded),
          ),
        ],
      ),
      body: Center(
        child: ListView.separated(
          separatorBuilder: (context, index) => const Divider(
            height: 0,
          ),
          shrinkWrap: true,
          itemCount: args.postReplies.length,
          itemBuilder: (context, index) {
            Post reply = args.postReplies[index];
            return Padding(
              padding: const EdgeInsets.all(8),
              child: ReplyWidget(
                board: args.board,
                reply: reply,
                threadReplies: args.threadReplies,
              ),
            );
          },
        ),
      ),
    );
  }
}
