import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mobichan/features/core/core.dart';
import 'package:mobichan/features/core/widgets/responsive_width.dart';
import 'package:mobichan/features/post/post.dart';
import 'package:mobichan/localization.dart';
import 'package:mobichan_domain/mobichan_domain.dart';
import 'package:shimmer/shimmer.dart';
import 'package:easy_localization/easy_localization.dart';

import 'thread_page.dart';

extension ThreadPageBuilders on ThreadPage {
  PopupMenuButton<dynamic> buildPopupMenuButton({
    required BuildContext context,
    required ScrollController scrollController,
    required Board board,
    required Post thread,
  }) {
    return PopupMenuButton(
      onSelected: (selection) =>
          handleSelectedAction(context, selection, board, thread),
      itemBuilder: (context) {
        return <PopupMenuEntry>[
          PopupMenuItem(
            child: const Text(refresh).tr(),
            value: 'refresh',
          ),
          PopupMenuItem(
            child: const Text(share).tr(),
            value: 'share',
          ),
          PopupMenuItem(
            child: const Text(goTop).tr(),
            value: 'top',
          ),
          PopupMenuItem(
            child: const Text(goBottom).tr(),
            value: 'bottom',
          ),
        ];
      },
    );
  }

  Widget buildLoading(Board board, Post thread) {
    return ResponsiveWidth(
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        children: [
          Hero(
            tag: thread.no,
            child: ThreadWidget(
              thread: thread,
              board: board,
              inThread: true,
            ),
          ),
          Expanded(
            child: Shimmer.fromColors(
              baseColor: Colors.grey.shade700,
              highlightColor: Colors.grey.shade600,
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(
                        left: RandomUtils.randomInt(0, 6) * 15.0 + 8.0,
                        top: 8.0,
                        bottom: 8.0,
                        right: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 100,
                          height: 10,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        Container(
                          width: 300,
                          height: 10,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        Container(
                          width: 250,
                          height: 10,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  static List<ReplyWidget> buildRootReplies(ComputeArgs args) {
    List<ReplyWidget> widgets = [];
    List<Post> rootReplies = args.replies
        .where((reply) =>
            reply.isRootPost ||
            reply.replyingTo(args.replies).first == args.thread.no)
        .toList();
    for (Post rootReply in rootReplies) {
      if (rootReply != args.thread) {
        widgets.add(
          ReplyWidget(
            board: args.board,
            reply: rootReply,
            threadReplies: args.replies,
            recursion: 0,
          ),
        );
        widgets.addAll(buildSubReplies(
          board: args.board,
          post: rootReply,
          replyWidgets: [],
          threadReplies: args.replies,
          recursion: 1,
        ));
      }
    }
    return widgets;
  }

  static List<ReplyWidget> buildSubReplies({
    required Board board,
    required Post post,
    required List<ReplyWidget> replyWidgets,
    required List<Post> threadReplies,
    required int recursion,
  }) {
    List<Post> postReplies = post
        .getReplies(threadReplies)
        .where((reply) => reply.replyingTo(threadReplies).first == post.no)
        .toList();
    if (postReplies.isEmpty) {
      return replyWidgets;
    } else {
      List<ReplyWidget> result = [];
      for (Post reply in postReplies) {
        result = buildSubReplies(
          board: board,
          post: reply,
          replyWidgets: replyWidgets
            ..add(
              ReplyWidget(
                board: board,
                reply: reply,
                threadReplies: threadReplies,
                recursion: recursion,
              ),
            ),
          threadReplies: threadReplies,
          recursion: recursion + 1,
        );
      }
      return result;
    }
  }

  Widget buildLinearReplies({
    required Board board,
    required Post thread,
    required List<Post> replies,
    required ScrollController scrollController,
  }) {
    return Scrollbar(
      isAlwaysShown: true,
      controller: scrollController,
      child: ListView.separated(
        separatorBuilder: (context, index) => const Divider(),
        controller: scrollController,
        itemCount: replies.length,
        itemBuilder: (context, index) {
          if (index == 0) {
            return ResponsiveWidth(
              child: Hero(
                tag: thread.no,
                child: ThreadWidget(
                  thread: thread,
                  board: board,
                  inThread: true,
                ),
              ),
            );
          }
          Post reply = replies[index];
          return ResponsiveWidth(
            child: ReplyWidget(
              board: board,
              reply: reply,
              threadReplies: replies,
            ),
          );
        },
      ),
    );
  }

  Widget buildThreadedReplies({
    required Board board,
    required Post thread,
    required List<Post> replies,
    required ScrollController scrollController,
  }) {
    return FutureBuilder<List<ReplyWidget>>(
      future: compute<ComputeArgs, List<ReplyWidget>>(
        buildRootReplies,
        ComputeArgs(
          board: board,
          thread: thread,
          replies: replies,
        ),
      ),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Scrollbar(
            isAlwaysShown: true,
            controller: scrollController,
            child: ListView.builder(
              controller: scrollController,
              shrinkWrap: true,
              itemCount: snapshot.data!.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return ResponsiveWidth(
                    child: Hero(
                      tag: thread.no,
                      child: ThreadWidget(
                        thread: thread,
                        board: board,
                        inThread: true,
                      ),
                    ),
                  );
                }
                ReplyWidget widget = snapshot.data![index - 1];
                return ResponsiveWidth(child: widget);
              },
            ),
          );
        } else {
          return buildLoading(board, thread);
        }
      },
    );
  }
}