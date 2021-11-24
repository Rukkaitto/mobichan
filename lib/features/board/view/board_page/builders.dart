import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobichan/features/board/board.dart';
import 'package:mobichan/features/core/core.dart';
import 'package:mobichan/features/post/post.dart';
import 'package:mobichan/features/sort/sort.dart';
import 'package:mobichan/localization.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mobichan_domain/mobichan_domain.dart';

extension BoardPageBuilders on BoardPage {
  PreferredSize buildAppBar(BuildContext context, Board board) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(100),
      child: BlocBuilder<SearchCubit, SearchState>(
        builder: (context, state) {
          return AppBar(
            leading: Builder(
              builder: (context) {
                if (state is Searching) {
                  return const BackButton();
                } else {
                  return IconButton(
                    onPressed: () => handleDrawerButtonPressed(context),
                    icon: Icon(
                      Icons.menu,
                      size: 30,
                      color: Theme.of(context).disabledColor,
                    ),
                  );
                }
              },
            ),
            centerTitle: false,
            title: state is Searching
                ? TextField(
                    onChanged: (input) =>
                        handleSearchFieldChanged(context, input),
                    decoration: InputDecoration(
                      hintText: search.tr(),
                    ),
                    autofocus: true,
                  )
                : Text(
                    boards,
                    style: Theme.of(context).textTheme.headline1,
                  ).tr(),
            bottom: const PreferredSize(
              child: BoardTabs(),
              preferredSize: Size.fromHeight(40.0),
            ),
            actions: [
              buildFavoriteButton(context, board),
              IconButton(
                onPressed: () => handleSearchIconPressed(context),
                icon: const Icon(Icons.search),
              ),
              buildPopupMenu(),
            ],
          );
        },
      ),
    );
  }

  Widget buildTabBarView(Board board, List<Board> boards) {
    return Stack(
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            return TabBarView(
              physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
              children: boards
                  .map(
                    (board) => ThreadsPage(board),
                  )
                  .toList(),
            );
          },
        ),
        FormWidget(board: board),
      ],
    );
  }

  Widget buildPopupMenu() {
    return BlocBuilder<SortCubit, SortState>(
      builder: (context, state) {
        if (state is SortLoaded) {
          return PopupMenuButton<Sort>(
            icon: const Icon(Icons.sort),
            onSelected: (Sort sort) => handleSortSelected(context, sort),
            itemBuilder: (context) {
              return [
                buildPopupMenuItem(
                    sortBumpOrder, const Sort(order: Order.byBump),
                    currentSort: state.sort),
                buildPopupMenuItem(
                    sortReplies, const Sort(order: Order.byReplies),
                    currentSort: state.sort),
                buildPopupMenuItem(
                    sortImages, const Sort(order: Order.byImages),
                    currentSort: state.sort),
                buildPopupMenuItem(sortNewest, const Sort(order: Order.byNew),
                    currentSort: state.sort),
                buildPopupMenuItem(sortOldest, const Sort(order: Order.byOld),
                    currentSort: state.sort),
              ];
            },
          );
        } else {
          return Container();
        }
      },
    );
  }

  PopupMenuItem<Sort> buildPopupMenuItem(String title, Sort sort,
      {required Sort currentSort}) {
    return PopupMenuItem<Sort>(
      value: sort,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title).tr(),
          if (sort.order == currentSort.order)
            const Icon(
              Icons.check_rounded,
              size: 20,
            ),
        ],
      ),
    );
  }

  Widget buildFavoriteButton(BuildContext context, Board board) {
    return BlocBuilder<FavoritesCubit, FavoritesState>(
      builder: (context, state) {
        final isInFavorites =
            state is FavoritesLoaded ? state.favorites.contains(board) : false;
        return IconButton(
          onPressed: () =>
              handleFavoriteIconPressed(context, board, isInFavorites),
          icon: Icon(isInFavorites ? Icons.favorite : Icons.favorite_border),
        );
      },
    );
  }
}
