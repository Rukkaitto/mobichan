import 'package:flutter/material.dart';
import 'package:mobichan/features/board/board.dart';
import 'package:mobichan/features/post/post.dart';
import 'package:mobichan_domain/mobichan_domain.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

extension BoardDrawerHandlers on BoardDrawer {
  void handleBoardTap(BuildContext context, Board board) {
    context.read<NsfwWarningCubit>().dismiss();
    context.read<TabsCubit>().setCurrentTab(board);
    Navigator.pop(context);
  }

  void handleFavoritePressed(
      BuildContext context, bool isFavorite, Board board) async {
    final favoriteCubit = context.read<FavoriteCubit>();
    final tabsCubit = context.read<TabsCubit>();
    if (isFavorite) {
      await favoriteCubit.removeFromFavorites(board);
    } else {
      await favoriteCubit.addToFavorites(board);
      tabsCubit.addTab(board);
    }
    context.read<FavoritesCubit>().getFavorites();
  }

  void handleOnHistoryTap(BuildContext context, Post thread) {
    Navigator.of(context).pushNamed(
      ThreadPage.routeName,
      arguments: ThreadPageArguments(board: thread.board!, thread: thread),
    );
  }
}
