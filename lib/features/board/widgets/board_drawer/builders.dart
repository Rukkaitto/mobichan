import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobichan/dependency_injector.dart';
import 'package:mobichan/features/board/board.dart';
import 'package:mobichan/core/core.dart';
import 'package:mobichan/features/post/post.dart';
import 'package:mobichan/features/setting/setting.dart';
import 'package:mobichan/features/theme/view/view.dart';
import 'package:mobichan/localization.dart';
import 'package:mobichan_domain/mobichan_domain.dart';
import 'package:shimmer/shimmer.dart';
import 'package:easy_localization/easy_localization.dart';

extension BoardDrawerBuilders on BoardDrawer {
  Container buildVersionInfo() {
    return Container(
      padding: const EdgeInsets.all(10.0),
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
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: [
        buildBoards(),
        buildHistory(),
        buildThemes(),
        buildSettings(),
      ],
    );
  }

  Widget buildThemes() {
    return Builder(
      builder: (context) {
        return BoardExpansionTileWidget(
          onTap: () => Navigator.pushNamed(context, ThemePage.routeName),
          title: 'Themes',
          icon: Icons.brush_rounded,
        );
      },
    );
  }

  Widget buildSettings() {
    return Builder(builder: (context) {
      return BoardExpansionTileWidget(
        onTap: () {
          Navigator.of(context).pushNamed(SettingsPage.routeName);
        },
        title: kSettings.tr(),
        icon: Icons.settings,
      );
    });
  }

  Widget buildBoards() {
    return Builder(
      builder: (context) {
        return BlocProvider<SearchCubit>(
          create: (context) => SearchCubit(),
          child: BoardExpansionTileWidget(
            title: kBoards.tr(),
            icon: Icons.list,
            child: SizedBox(
              height: 450.0,
              child: BlocProvider<BoardsCubit>(
                create: (context) => sl<BoardsCubit>()..getBoards(),
                child: BlocListener<SearchCubit, SearchState>(
                  listener: (context, state) {
                    final boardsCubit = context.read<BoardsCubit>();
                    if (state is Searching) {
                      boardsCubit.search(state.input);
                    }
                    if (state is NotSearching) {
                      boardsCubit.search('');
                    }
                  },
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
            ),
          ),
        );
      },
    );
  }

  Widget buildBoardListTile(Board board) {
    return Builder(
      builder: (context) {
        return ListTile(
          onTap: () => handleBoardTap(context, board),
          dense: true,
          minVerticalPadding: 0,
          contentPadding: const EdgeInsets.only(left: 56),
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
    );
  }

  Widget buildBoardsLoading() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade700,
      highlightColor: Colors.grey.shade600,
      child: ListView.builder(itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(
              left: 56.0, top: 14.0, bottom: 14.0, right: 15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 180,
                height: 15.0,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
              const Icon(
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

  Widget buildHistory() {
    return BlocProvider<SearchCubit>(
      create: (context) => SearchCubit(),
      child: BoardExpansionTileWidget(
        title: kHistory.tr(),
        icon: Icons.history,
        child: SizedBox(
          height: 450.0,
          child: BlocListener<SearchCubit, SearchState>(
            listener: (context, state) {
              final historyCubit = context.read<HistoryCubit>();
              if (state is Searching) {
                historyCubit.search(state.input);
              }
              if (state is NotSearching) {
                historyCubit.search('');
              }
            },
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
        ),
      ),
    );
  }

  Widget buildFavoriteButton(Board board) {
    return Builder(
      builder: (context) {
        return BlocProvider<FavoriteCubit>(
          create: (context) => sl()..checkIfInFavorites(board),
          child: BlocBuilder<FavoriteCubit, bool>(
            builder: (context, isFavorite) {
              return IconButton(
                onPressed: () =>
                    handleFavoritePressed(context, isFavorite, board),
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
        onTap: () => handleOnHistoryTap(context, thread),
        contentPadding: const EdgeInsets.only(left: 56, right: 10),
        dense: true,
        minVerticalPadding: 0,
        horizontalTitleGap: 0,
        trailing: Text(
          '/${thread.boardId}/',
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
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
