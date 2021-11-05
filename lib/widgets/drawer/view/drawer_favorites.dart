import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobichan/classes/arguments/board_page_arguments.dart';
import 'package:mobichan/pages/board_page.dart';
import 'package:mobichan/widgets/drawer/cubit/favorites_cubit/favorites_cubit.dart';
import 'package:mobichan_domain/mobichan_domain.dart';

class DrawerFavorites extends StatelessWidget {
  final _scrollController = ScrollController();

  DrawerFavorites({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoritesCubit, FavoritesState>(
      builder: (context, state) {
        if (state is FavoritesLoaded) {
          return Scrollbar(
            controller: _scrollController,
            isAlwaysShown: true,
            child: ListView.separated(
              separatorBuilder: (context, index) => Divider(
                color: Colors.grey,
              ),
              controller: _scrollController,
              physics: AlwaysScrollableScrollPhysics(),
              itemCount: state.favorites.length,
              itemBuilder: (context, index) {
                Board board = state.favorites[index];
                return buildListTile(board, context);
              },
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }

  void goToBoard(BuildContext context, Board board) {
    context.read<BoardRepository>().saveLastVisitedBoard(board);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BoardPage(
          args: BoardPageArguments(
            board: board.board,
            title: board.title,
            wsBoard: board.wsBoard,
          ),
        ),
      ),
    );
  }

  ListTile buildListTile(Board board, BuildContext context) {
    return ListTile(
      title: Text(board.fullTitle),
      onTap: () => goToBoard(context, board),
    );
  }
}
