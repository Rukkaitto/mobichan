import 'package:configurable_expansion_tile_null_safety/configurable_expansion_tile.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobichan/dependency_injector.dart';
import 'package:mobichan/localization.dart';

import 'package:mobichan/features/board/board.dart';
import 'package:mobichan_domain/mobichan_domain.dart';

class BoardDrawer extends StatelessWidget {
  const BoardDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildMenuList(context),
            buildVersionInfo(),
          ],
        ),
      ),
    );
  }

  Container buildVersionInfo() {
    return Container(
      padding: EdgeInsets.all(10.0),
      width: double.infinity,
      child: Text('test'),
    );
  }

  ListView buildMenuList(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: [
        ConfigurableExpansionTile(
          header: Expanded(
            child: Row(
              children: [
                Icon(Icons.list),
                Text(boards).tr(),
              ],
            ),
          ),
          children: [
            SizedBox(
              height: 500.0,
              child: BlocProvider<BoardsCubit>(
                create: (context) => sl<BoardsCubit>()..getBoards(),
                child: BlocBuilder<BoardsCubit, BoardsState>(
                  builder: (context, state) {
                    if (state is BoardsLoaded) {
                      return buildBoards(state.boards);
                    } else {
                      return buildLoading();
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  ListView buildBoards(List<Board> boards) {
    return ListView.builder(
      itemCount: boards.length,
      itemBuilder: (context, index) {
        Board board = boards[index];
        return buildListTile(board);
      },
    );
  }

  BlocProvider buildListTile(Board board) {
    return BlocProvider<FavoriteCubit>(
      create: (context) => sl<FavoriteCubit>()..checkIfInFavorites(board),
      child: BlocBuilder<FavoriteCubit, bool>(
        builder: (context, isFavorite) {
          return ListTile(
            title: RichText(
              text: TextSpan(
                text: board.title,
                children: <TextSpan>[
                  TextSpan(
                    text: ' /${board.board}/',
                    style: TextStyle(color: Colors.grey.shade500),
                  ),
                ],
              ),
            ),
            trailing: IconButton(
              onPressed: () => handleOnFavoritePressed(
                context,
                board,
                isFavorite,
              ),
              icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
            ),
          );
        },
      ),
    );
  }

  Widget buildLoading() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  void handleOnFavoritePressed(
    BuildContext context,
    Board board,
    bool isFavorite,
  ) async {
    final favoriteCubit = context.read<FavoriteCubit>();
    final favoritesCubit = context.read<FavoritesCubit>();
    if (isFavorite) {
      await favoriteCubit.removeFromFavorites(board);
    } else {
      await favoriteCubit.addToFavorites(board);
    }
    await favoritesCubit.getFavorites();
  }
}
