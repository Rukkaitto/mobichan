import 'package:flutter/material.dart';
import 'package:mobichan/core/core.dart';
import 'package:mobichan/features/post/post.dart';
import 'package:mobichan_domain/mobichan_domain.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share/share.dart';

import 'thread_page.dart';

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

  void handleScrollTop() {
    scrollController.jumpTo(scrollController.position.minScrollExtent);
  }

  void handleScrollBottom() {
    scrollController.jumpTo(scrollController.position.maxScrollExtent);
  }

  void handleSelectedAction(
      BuildContext context, String selection, Board board, Post thread) {
    switch (selection) {
      case 'refresh':
        handleRefresh(context, board, thread);
        break;
      case 'share':
        handleShare(board, thread);
        break;
      case 'top':
        handleScrollTop();
        break;
      case 'bottom':
        handleScrollBottom();
        break;
    }
  }

  void handleGalleryButton(
      BuildContext context, Board board, List<Post> imagePosts) {
    Navigator.of(context).pushNamed(
      GalleryPage.routeName,
      arguments: GalleryPageArguments(board: board, imagePosts: imagePosts),
    );
  }
}
