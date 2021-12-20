import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:mobichan/core/core.dart';
import 'package:mobichan/features/post/post.dart';
import 'package:mobichan/localization.dart';
import 'package:mobichan_domain/mobichan_domain.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:shimmer/shimmer.dart';
import 'package:easy_localization/easy_localization.dart';

extension ThreadPageBuilders on ThreadPage {
  PopupMenuButton<dynamic> buildPopupMenuButton({
    required BuildContext context,
    required Board board,
    required Post thread,
    required List<Post> replies,
  }) {
    return PopupMenuButton(
      itemBuilder: (context) {
        return <PopupMenuEntry>[
          PopupMenuItem(
            child: const Text(kRefresh).tr(),
            onTap: () => handleRefresh(context, board, thread),
          ),
          PopupMenuItem(
            child: const Text(kShare).tr(),
            onTap: () => handleShare(board, thread),
          ),
          PopupMenuItem(
            child: const Text(kGoTop).tr(),
            onTap: () => handleScrollTop(replies),
          ),
          PopupMenuItem(
            child: const Text(kGoBottom).tr(),
            onTap: () => handleScrollBottom(replies),
          ),
        ];
      },
    );
  }

  Widget buildLoading(Board board, Post thread) {
    return ResponsiveWidth(
      fullWidth: Device.get().isTablet,
      child: ListView(
        children: [
          Hero(
            tag: thread.no,
            child: ThreadWidget(
              thread: thread,
              board: board,
              inThread: true,
              threadContent: ContentWidget(
                board: board,
                reply: thread,
                threadReplies: const [],
              ),
            ),
          ),
          Shimmer.fromColors(
            baseColor: Colors.grey.shade700,
            highlightColor: Colors.grey.shade600,
            child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: 10,
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
        ],
      ),
    );
  }

  static List<PostWithDepth> buildRootReplies(ComputeArgs args) {
    List<PostWithDepth> postsWithDepth = [];
    List<Post> rootReplies = args.replies
        .where((reply) =>
            reply.isRootPost ||
            reply.replyingTo(args.replies).first == args.thread)
        .toList();
    for (Post rootReply in rootReplies) {
      if (rootReply.no != args.thread.no) {
        postsWithDepth.add(
          PostWithDepth(depth: 0, post: rootReply),
          // ReplyWidget(
          //   board: args.board,
          //   post: rootReply,
          //   threadReplies: args.replies,
          //   recursion: 0,
          // ),
        );
        postsWithDepth.addAll(buildSubReplies(
          board: args.board,
          post: rootReply,
          postsWithDepth: [],
          threadReplies: args.replies,
          recursion: 1,
        ));
      }
    }
    return postsWithDepth;
  }

  static List<PostWithDepth> buildSubReplies({
    required Board board,
    required Post post,
    required List<PostWithDepth> postsWithDepth,
    required List<Post> threadReplies,
    required int recursion,
  }) {
    const maxRecursion = 7;
    if (recursion > maxRecursion) return postsWithDepth;
    List<Post> postReplies = post
        .getReplies(threadReplies)
        .where((reply) => reply.replyingTo(threadReplies).first == post)
        .toList();
    if (postReplies.isEmpty) {
      return postsWithDepth;
    } else {
      List<PostWithDepth> result = [];
      for (Post reply in postReplies) {
        result = buildSubReplies(
          board: board,
          post: reply,
          postsWithDepth: postsWithDepth..add(
              // ReplyWidget(
              //   board: board,
              //   post: reply,
              //   threadReplies: threadReplies,
              //   recursion: recursion,
              //   showReplies: recursion == maxRecursion,
              // ),
              PostWithDepth(depth: recursion, post: reply)),
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
  }) {
    return Scrollbar(
      child: ScrollablePositionedList.separated(
        separatorBuilder: (context, index) => const Divider(),
        itemScrollController: itemScrollController,
        itemCount: replies.length,
        itemBuilder: (context, index) {
          if (index == 0) {
            return ResponsiveWidth(
              fullWidth: Device.get().isTablet,
              child: Hero(
                tag: thread.no,
                child: ThreadWidget(
                  thread: thread,
                  board: board,
                  inThread: true,
                  threadContent: ContentWidget(
                    board: board,
                    reply: thread,
                    threadReplies: replies,
                  ),
                  onImageTap: () => handleTapThreadImage(
                    context: context,
                    board: board,
                    imagePosts: replies.imagePosts,
                  ),
                ),
              ),
            );
          }
          Post reply = replies[index];
          return ResponsiveWidth(
            fullWidth: Device.get().isTablet,
            child: ReplyWidget(
              board: board,
              post: reply,
              threadReplies: replies,
              showReplies: true,
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
  }) {
    return FutureBuilder<List<PostWithDepth>>(
      future: compute<ComputeArgs, List<PostWithDepth>>(
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
            child: ScrollablePositionedList.builder(
              itemScrollController: itemScrollController,
              shrinkWrap: true,
              itemCount: snapshot.data!.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return ResponsiveWidth(
                    fullWidth: Device.get().isTablet,
                    child: Hero(
                      tag: thread.no,
                      child: ThreadWidget(
                        thread: thread,
                        board: board,
                        inThread: true,
                        threadContent: ContentWidget(
                          board: board,
                          reply: thread,
                          threadReplies: replies,
                        ),
                        onImageTap: () => handleTapThreadImage(
                          context: context,
                          board: board,
                          imagePosts: replies.imagePosts,
                        ),
                      ),
                    ),
                  );
                }
                PostWithDepth postWithDepth = snapshot.data![index - 1];
                return ResponsiveWidth(
                  fullWidth: Device.get().isTablet,
                  child: ReplyWidget(
                    board: board,
                    post: postWithDepth.post,
                    threadReplies: replies,
                    recursion: postWithDepth.depth,
                  ),
                );
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
