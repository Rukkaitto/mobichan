import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobichan/classes/arguments/board_page_arguments.dart';
import 'package:mobichan/pages/board_page.dart';
import 'package:mobichan/pages/boards/cubit/favorite_cubit/favorite_cubit.dart';
import 'package:mobichan_domain/mobichan_domain.dart';

class BoardListTile extends StatelessWidget {
  final Board board;
  const BoardListTile(this.board, {Key? key}) : super(key: key);

  void goToBoard(BuildContext context, Board board) {
    context.read<BoardRepository>().saveLastVisitedBoard(board);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BoardPage(
          args: BoardPageArguments(board),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<FavoriteCubit>(
      create: (context) => FavoriteCubit(
        context.read<BoardRepository>(),
      )..checkIfInFavorites(board),
      child: BlocBuilder<FavoriteCubit, bool>(
        builder: (context, inFavorites) {
          final favoriteCubit = context.read<FavoriteCubit>();
          return ListTile(
            title: Text(board.fullTitle),
            trailing: IconButton(
              onPressed: () {
                inFavorites
                    ? favoriteCubit.removeFromFavorites(board)
                    : favoriteCubit.addToFavorites(board);
              },
              icon: Icon(inFavorites
                  ? Icons.favorite_rounded
                  : Icons.favorite_outline_rounded),
            ),
            onTap: () => goToBoard(context, board),
          );
        },
      ),
    );
  }
}
