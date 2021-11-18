import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobichan/dependency_injector.dart';
import 'package:mobichan/features/core/core.dart';
import 'package:mobichan/features/post/post.dart';
import 'package:mobichan/features/sort/sort.dart';
import 'package:mobichan/localization.dart';
import 'package:mobichan_domain/mobichan_domain.dart';
import 'package:mobichan/features/board/board.dart';

class BoardPage extends StatelessWidget {
  const BoardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SortCubit>(
          create: (_) => sl<SortCubit>()..getSort(),
        ),
        BlocProvider<HistoryCubit>(
          create: (_) => sl<HistoryCubit>()..getHistory(),
        ),
        BlocProvider<PostFormCubit>(
          create: (_) => PostFormCubit(),
        ),
        BlocProvider<ThreadsCubit>(
          create: (_) => sl<ThreadsCubit>(),
        ),
      ],
      child: BlocBuilder<TabsCubit, TabsState>(
        builder: (context, state) {
          if (state is TabsLoaded) {
            return DefaultTabController(
              length: state.boards.length,
              initialIndex: state.currentIndex,
              child: BlocProvider<SearchCubit>(
                create: (context) => SearchCubit(),
                child: Scaffold(
                  floatingActionButton: FloatingActionButton(
                    onPressed: () =>
                        context.read<PostFormCubit>().toggleVisible(),
                    child: Icon(Icons.edit),
                  ),
                  drawer: BoardDrawer(),
                  appBar: buildAppBar(context),
                  body: buildTabBarView(state.current, state.boards),
                ),
              ),
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }

  PreferredSize buildAppBar(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(100),
      child: BlocBuilder<SearchCubit, SearchState>(
        builder: (context, state) {
          return AppBar(
            leading: Builder(
              builder: (context) {
                if (state is Searching) {
                  return BackButton();
                } else {
                  return IconButton(
                    onPressed: () => Scaffold.of(context).openDrawer(),
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
                        context.read<SearchCubit>().updateInput(input),
                    decoration: InputDecoration(
                      hintText: search.tr(),
                    ),
                    autofocus: true,
                  )
                : Text(
                    boards,
                    style: Theme.of(context).textTheme.headline1,
                  ).tr(),
            bottom: PreferredSize(
              child: BoardTabs(),
              preferredSize: Size.fromHeight(40.0),
            ),
            actions: [
              IconButton(
                onPressed: () {
                  context.read<SearchCubit>().startSearching(context);
                },
                icon: Icon(Icons.search),
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
        TabBarView(
          physics:
              BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          children: boards
              .map(
                (board) => ThreadsPage(board),
              )
              .toList(),
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
            icon: Icon(Icons.sort),
            onSelected: (Sort sort) {
              context.read<SortCubit>().saveSort(sort);
            },
            itemBuilder: (context) {
              return [
                buildPopupMenuItem(sort_bump_order, Sort(order: Order.byBump),
                    currentSort: state.sort),
                buildPopupMenuItem(sort_replies, Sort(order: Order.byReplies),
                    currentSort: state.sort),
                buildPopupMenuItem(sort_images, Sort(order: Order.byImages),
                    currentSort: state.sort),
                buildPopupMenuItem(sort_newest, Sort(order: Order.byNew),
                    currentSort: state.sort),
                buildPopupMenuItem(sort_oldest, Sort(order: Order.byOld),
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
            Icon(
              Icons.check_rounded,
              size: 20,
            ),
        ],
      ),
    );
  }
}
