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
  Widget buildBuilder({
    required BuildContext context,
    required RepliesState repliesState,
    required ThreadPageArguments args,
  }) {
    if (repliesState is! RepliesLoaded) {
      return Scaffold(
        appBar: buildAppBar(
          context: context,
          board: args.board,
          thread: args.thread,
        ),
        body: buildLoading(),
      );
    }
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => handleFormButtonPressed(context),
        child: const Icon(Icons.edit),
      ),
      appBar: buildAppBar(
        context: context,
        board: args.board,
        thread: repliesState.replies.first,
        replies: repliesState.replies,
      ),
      body: RefreshIndicator(
        onRefresh: () async => handleRefresh(
          context: context,
          board: args.board,
          thread: repliesState.replies.first,
        ),
        child: SettingProvider(
          settingTitle: 'threaded_replies',
          loadingWidget: buildLoading(),
          builder: (threadedReplies) {
            return Stack(
              children: [
                threadedReplies.value
                    ? buildThreadedReplies(
                        board: args.board,
                        thread: repliesState.replies.first,
                        replies: repliesState.replies,
                      )
                    : buildLinearReplies(
                        board: args.board,
                        thread: repliesState.replies.first,
                        replies: repliesState.replies,
                      ),
                FormWidget(
                  board: args.board,
                  thread: args.thread,
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void buildListener(context, repliesState) {
    if (repliesState is RepliesLoaded) {
      final replies = repliesState.replies;
      repliesCountHistory.add(replies.length);
      final repliesCount = handleNewRepliesCount(replies);
      if (repliesCount <= 0) return;
      ScaffoldMessenger.of(context).showSnackBar(
        successSnackbar(
          context,
          kLoadedReplies.plural(repliesCount),
        ),
      );
    }
  }

  AppBar buildAppBar({
    required BuildContext context,
    required Board board,
    required Post thread,
    List<Post> replies = const [],
  }) {
    return AppBar(
      title: Text(thread.displayTitle.replaceBrWithSpace.removeHtmlTags),
      actions: [
        IconButton(
          icon: const Icon(Icons.image),
          onPressed: () => handleGalleryButton(
            context,
            board,
            replies.where((element) => element.filename != null).toList(),
          ),
        ),
        buildPopupMenuButton(
          context: context,
          board: board,
          thread: thread,
          replies: replies,
        ),
      ],
    );
  }

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
            onTap: () => handleRefresh(
              context: context,
              board: board,
              thread: thread,
            ),
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

  Widget buildLoading() {
    return ResponsiveWidth(
      fullWidth: Device.get().isTablet,
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade700,
        highlightColor: Colors.grey.shade600,
        child: ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            if (index == 0) {
              return buildLoadingOP();
            }
            return buildLoadingReplies(index - 1);
          },
        ),
      ),
    );
  }

  Widget buildLoadingReplies(int index) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Padding(
        padding: EdgeInsets.only(left: 15.0 * (index % 3)),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextShimmer(width: 100),
            SizedBox(height: 10.0),
            TextShimmer(width: 300),
            SizedBox(height: 8.0),
            TextShimmer(width: 250),
          ],
        ),
      ),
    );
  }

  Widget buildLoadingOP() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(10.0),
          child: TextShimmer(width: 200),
        ),
        Container(
          height: 250,
          color: Colors.white,
        ),
        const Padding(
          padding: EdgeInsets.only(
            top: 10.0,
            left: 10.0,
            right: 10.0,
          ),
          child: TextShimmer(),
        ),
        const Padding(
          padding: EdgeInsets.all(10.0),
          child: TextShimmer(width: 200),
        ),
        const Padding(
          padding: EdgeInsets.all(15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextShimmer(width: 100),
              SizedBox(
                width: 100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconShimmer(icon: Icons.reply),
                    IconShimmer(icon: Icons.image),
                    IconShimmer(icon: Icons.reply),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
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
    if (recursion > ThreadPage.maxRecursion) return postsWithDepth;
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
          postsWithDepth: postsWithDepth
            ..add(
              PostWithDepth(depth: recursion, post: reply),
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
  }) {
    return Scrollbar(
      child: ScrollablePositionedList.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.only(bottom: 120.0),
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
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.only(bottom: 120.0),
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
                    showReplies: postWithDepth.depth == ThreadPage.maxRecursion,
                  ),
                );
              },
            ),
          );
        } else {
          return buildLoading();
        }
      },
    );
  }
}
