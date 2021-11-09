import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobichan/dependency_injector.dart';
import 'package:mobichan/features/core/widgets/snackbars/error_snackbar.dart';
import 'package:mobichan/localization.dart';
import 'package:mobichan_domain/mobichan_domain.dart';
import 'package:mobichan/features/board/board.dart';

class BoardPage extends StatelessWidget {
  final Board initialBoard;

  const BoardPage({required this.initialBoard, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<FavoritesCubit>(
      create: (context) => sl<FavoritesCubit>()..getFavorites(),
      child: BlocConsumer<FavoritesCubit, FavoritesState>(
        listener: (context, state) {
          if (state is FavoritesError) {
            ScaffoldMessenger.of(context).showSnackBar(
              errorSnackbar(context, 'Could not load favorites.'),
            );
          }
        },
        builder: (context, state) {
          if (state is FavoritesLoaded) {
            List<Board> boards = List.from(state.favorites);
            if (!state.favorites.contains(initialBoard)) {
              boards.add(initialBoard);
              boards.sort();
            }
            return buildDefaultTabController(boards);
          } else {
            return Container();
          }
        },
      ),
    );
  }

  DefaultTabController buildDefaultTabController(List<Board> favorites) {
    return DefaultTabController(
      initialIndex: favorites.indexWhere((board) => board == initialBoard),
      length: favorites.length,
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: Icon(Icons.edit),
        ),
        drawer: BoardDrawer(),
        appBar: AppBar(
          title: Text(boards).tr(),
          bottom: PreferredSize(
            child: BoardTabs(favorites),
            preferredSize: Size.fromHeight(40.0),
          ),
        ),
        body: buildTabBarView(favorites),
      ),
    );
  }

  TabBarView buildTabBarView(List<Board> favorites) {
    return TabBarView(
      children: favorites
          .map(
            (board) => ThreadsPage(board),
          )
          .toList(),
    );
  }
}
