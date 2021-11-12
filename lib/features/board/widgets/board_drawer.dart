import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobichan/dependency_injector.dart';
import 'package:mobichan/features/post/cubits/cubits.dart';
import 'package:mobichan/localization.dart';

import 'package:mobichan/features/board/board.dart';
import 'package:mobichan/features/core/core.dart';
import 'package:mobichan_domain/mobichan_domain.dart';
import 'package:shimmer/shimmer.dart';

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
            buildMenuList(),
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
      child: BlocProvider<PackageInfoCubit>(
        create: (context) => sl<PackageInfoCubit>()..getPackageInfo(),
        child: BlocBuilder<PackageInfoCubit, PackageInfoState>(
          builder: (context, state) {
            if (state is PackageInfoLoaded) {
              return Text(
                'Version ${state.packageInfo.version}',
                style: Theme.of(context).textTheme.subtitle2,
              );
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }

  ListView buildMenuList() {
    return ListView(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: [
        buildBoards(),
        buildHistory(),
        BoardExpansionTile(
          onTap: () {
            print('Go to settings');
          },
          title: settings.tr(),
          icon: Icons.settings,
        ),
      ],
    );
  }

  Widget buildBoards() {
    return Builder(
      builder: (context) {
        return BoardExpansionTile(
          title: boards.tr(),
          icon: Icons.list,
          child: SizedBox(
            height: 500.0,
            child: BlocProvider<BoardsCubit>(
              create: (context) => sl<BoardsCubit>()..getBoards(),
              child: BlocBuilder<BoardsCubit, BoardsState>(
                builder: (context, state) {
                  if (state is BoardsLoaded) {
                    return ListView.builder(
                      itemCount: state.boards.length,
                      itemBuilder: (context, index) {
                        Board board = state.boards[index];
                        return buildBoardListTile(board);
                      },
                    );
                  } else {
                    return buildBoardsLoading();
                  }
                },
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildBoardsLoading() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade700,
      highlightColor: Colors.grey.shade600,
      child: ListView.builder(itemBuilder: (context, index) {
        return Padding(
          padding:
              EdgeInsets.only(left: 56.0, top: 14.0, bottom: 14.0, right: 15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 180,
                height: 15.0,
                color: Colors.white,
              ),
              Icon(
                Icons.favorite,
                color: Colors.white,
                size: 20.0,
              )
            ],
          ),
        );
      }),
    );
  }

  BoardExpansionTile buildHistory() {
    return BoardExpansionTile(
      title: history.tr(),
      icon: Icons.history,
      child: SizedBox(
        height: 500.0,
        child: BlocBuilder<HistoryCubit, HistoryState>(
          builder: (context, state) {
            if (state is HistoryLoaded) {
              return ListView.builder(
                itemCount: state.history.length,
                itemBuilder: (context, index) {
                  Post thread = state.history.reversed.toList()[index];
                  return buildHistoryListTile(thread);
                },
              );
            } else {
              return buildLoading();
            }
          },
        ),
      ),
    );
  }

  Widget buildBoardListTile(Board board) {
    return BlocProvider<FavoritesCubit>(
      create: (context) => sl<FavoritesCubit>()..getFavorites(),
      child: Builder(
        builder: (context) {
          return ListTile(
            onTap: () {
              context.read<TabsCubit>().addTab(board);
              Navigator.pop(context);
            },
            dense: true,
            minVerticalPadding: 0,
            contentPadding: EdgeInsets.only(left: 56),
            horizontalTitleGap: 0,
            title: RichText(
              text: TextSpan(
                text: board.title,
                children: <TextSpan>[
                  TextSpan(
                    text: ' /${board.board}/',
                    style: Theme.of(context).textTheme.caption,
                  ),
                ],
              ),
            ),
            trailing: buildFavoriteButton(board),
          );
        },
      ),
    );
  }

  Widget buildFavoriteButton(Board board) {
    return Builder(
      builder: (context) {
        return BlocProvider<FavoriteCubit>(
          create: (context) => sl<FavoriteCubit>()..checkIfInFavorites(board),
          child: BlocBuilder<FavoriteCubit, bool>(
            builder: (context, isFavorite) {
              return IconButton(
                onPressed: () async {
                  final favoriteCubit = context.read<FavoriteCubit>();
                  final tabsCubit = context.read<TabsCubit>();
                  if (isFavorite) {
                    await favoriteCubit.removeFromFavorites(board);
                    tabsCubit.removeTab(board);
                  } else {
                    await favoriteCubit.addToFavorites(board);
                    tabsCubit.addTab(board);
                  }
                },
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  size: 20,
                  color: isFavorite
                      ? Theme.of(context).colorScheme.secondary
                      : Theme.of(context).iconTheme.color,
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget buildHistoryListTile(Post thread) {
    return Builder(builder: (context) {
      return ListTile(
        onTap: () {
          //TODO: Open thread
        },
        contentPadding: EdgeInsets.only(left: 56, right: 10),
        dense: true,
        minVerticalPadding: 0,
        horizontalTitleGap: 0,
        trailing: Text(
          '/${thread.board!.board}/',
          style: Theme.of(context).textTheme.caption,
        ),
        title: Text(
          thread.displayTitle.removeHtmlTags,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      );
    });
  }

  Widget buildLoading() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}
