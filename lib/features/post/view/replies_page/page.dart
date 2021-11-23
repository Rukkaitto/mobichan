import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobichan/features/post/post.dart';
import 'package:mobichan/localization.dart';
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
  final Board board;
  final List<Post> postReplies;
  final List<Post> threadReplies;

  const RepliesPage({
    required this.board,
    required this.postReplies,
    required this.threadReplies,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: BlocProvider<RepliesDialogCubit>(
        create: (context) => RepliesDialogCubit(postReplies),
        child: BlocBuilder<RepliesDialogCubit, List<Post>>(
          builder: (context, replies) {
            return Scaffold(
              appBar: AppBar(
                title: Text('reply'.plural(replies.length)),
                leading: Container(),
                actions: [
                  IconButton(
                    onPressed: () => handleClose(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              body: Scrollbar(
                isAlwaysShown: true,
                child: ListView.separated(
                  separatorBuilder: (context, index) => const Divider(
                    height: 0,
                  ),
                  shrinkWrap: true,
                  itemCount: replies.length,
                  itemBuilder: (context, index) {
                    Post reply = replies[index];
                    return Padding(
                      padding: const EdgeInsets.all(8),
                      child: ReplyWidget(
                        board: board,
                        reply: reply,
                        threadReplies: threadReplies,
                        inDialog: true,
                      ),
                    );
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
