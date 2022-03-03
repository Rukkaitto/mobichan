import 'package:flutter/material.dart';
import 'package:mobichan/core/core.dart';
import 'package:mobichan/features/post/post.dart';
import 'package:mobichan_domain/mobichan_domain.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share/share.dart';

extension ThreadPageHandlers on ThreadPage {
  void handleRefresh(BuildContext context, Board board, Post thread) async {
    await context.read<RepliesCubit>().getReplies(board, thread);
  }

  void handleFormButtonPressed(BuildContext context) {
    context.read<PostFormCubit>().toggleVisible();
  }

  void handleShare(Board board, Post thread) {
    Share.share(
        'https://boards.4channel.org/${board.board}/thread/${thread.no}');
  }

  void handleScrollTop(List<Post> replies) {
    itemScrollController.scrollTo(
      index: 0,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
    );
  }

  void handleScrollBottom(List<Post> replies) {
    itemScrollController.scrollTo(
      index: replies.length,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
    );
  }

  void handleGalleryButton(
      BuildContext context, Board board, List<Post> imagePosts) {
    Navigator.of(context).pushNamed(
      GalleryPage.routeName,
      arguments: GalleryPageArguments(board: board, imagePosts: imagePosts),
    );
  }

  void handleTapThreadImage({
    required BuildContext context,
    required Board board,
    required List<Post> imagePosts,
  }) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        pageBuilder: (context, _, __) => CarouselPage(
          board: board,
          posts: imagePosts,
          imageIndex: 0,
          heroTitle: "image0",
        ),
      ),
    );
  }

  int handleNewRepliesCount(List<Post> replies) {
    if (repliesCountHistory.isEmpty || repliesCountHistory.length == 1) {
      return replies.length - 1; // Omits the OP
    }
    final last = repliesCountHistory.last;
    final beforeLast =
        repliesCountHistory.elementAt(repliesCountHistory.length - 2);
    final newRepliesCount = last - beforeLast;
    return newRepliesCount - 1; // Omits the OP
  }
}
