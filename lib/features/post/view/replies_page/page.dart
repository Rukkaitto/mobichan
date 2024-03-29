import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobichan/features/post/post.dart';
import 'package:mobichan/localization.dart';
import 'package:mobichan_domain/mobichan_domain.dart';

class RepliesPage extends StatelessWidget {
  final Board board;
  final List<Post> postReplies;
  final List<Post> threadReplies;
  final Post? replyingTo;

  const RepliesPage({
    required this.board,
    required this.postReplies,
    required this.threadReplies,
    this.replyingTo,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: BlocProvider<RepliesDialogCubit>(
        create: (context) => RepliesDialogCubit(postReplies, replyingTo),
        child: BlocBuilder<RepliesDialogCubit, List<RepliesDialogState>>(
          builder: (context, repliesHistory) {
            List<Post> lastReplies = repliesHistory.last.replies;
            return WillPopScope(
              onWillPop: () async {
                if (repliesHistory.length > 1) {
                  context.read<RepliesDialogCubit>().pop();
                  return false;
                }
                return true;
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppBar(
                    title: Text(kReply.plural(lastReplies.length)),
                    leading: repliesHistory.length > 1
                        ? BackButton(
                            onPressed: () =>
                                handleBack(context, repliesHistory),
                          )
                        : Container(),
                    actions: [
                      IconButton(
                        onPressed: () => handleClose(context),
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                  Flexible(
                    child: Container(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      child: Scrollbar(
                        child: ListView.separated(
                          separatorBuilder: (context, index) => const Divider(
                            height: 0,
                          ),
                          shrinkWrap: true,
                          itemCount: lastReplies.length,
                          itemBuilder: (context, index) {
                            Post reply = lastReplies[index];
                            return Padding(
                              padding: const EdgeInsets.all(8),
                              child: ReplyWidget(
                                board: board,
                                post: reply,
                                replyingTo: repliesHistory.last.replyingTo,
                                threadReplies: threadReplies,
                                inDialog: true,
                                showReplies: true,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
