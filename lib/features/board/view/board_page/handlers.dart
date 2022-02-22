import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobichan/features/board/board.dart';
import 'package:mobichan/core/core.dart';
import 'package:mobichan/features/sort/sort.dart';
import 'package:mobichan_domain/mobichan_domain.dart';

extension BoardPageHandlers on BoardPage {
  void handleFormButtonPressed(BuildContext context) {
    context.read<PostFormCubit>().toggleVisible();
  }

  void handleDrawerButtonPressed(BuildContext context) {
    Scaffold.of(context).openDrawer();
  }

  void handleSearchFieldChanged(BuildContext context, String input) {
    context.read<SearchCubit>().updateInput(input);
  }

  void handleSearchIconPressed(BuildContext context) {
    context.read<SearchCubit>().startSearching(context);
  }

  void handleSortSelected(BuildContext context, Sort sort) {
    context.read<SortCubit>().saveSort(sort);
  }

  void handleFavoriteIconPressed(
      BuildContext context, Board board, bool isInFavorites) {
    if (isInFavorites) {
      context.read<FavoritesCubit>().removeFromFavorites(board);
    } else {
      context.read<FavoritesCubit>().addToFavorites(board);
    }
    context.read<FavoritesCubit>().getFavorites();
  }

  void handleOnDismissWarning(BuildContext context) {
    context.read<NsfwWarningCubit>().dismiss();
  }
}
