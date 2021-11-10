import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobichan/dependency_injector.dart';
import 'package:mobichan/features/core/core.dart';
import 'package:mobichan/localization.dart';
import 'package:mobichan_domain/mobichan_domain.dart';
import 'package:mobichan/features/board/board.dart';

class BoardPage extends StatelessWidget {
  const BoardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TabsCubit>(
      create: (context) => sl<TabsCubit>()..getInitialTabs(),
      child: BlocBuilder<TabsCubit, Tabs>(
        builder: (context, tabs) {
          print(tabs.boards.length);
          return DefaultTabController(
            length: tabs.boards.length,
            initialIndex: tabs.boards.indexOf(tabs.current),
            child: BlocProvider<SearchCubit>(
              create: (context) => SearchCubit(),
              child: Scaffold(
                floatingActionButton: FloatingActionButton(
                  onPressed: () {},
                  child: Icon(Icons.edit),
                ),
                drawer: BoardDrawer(),
                appBar: buildAppBar(context, tabs),
                body: buildTabBarView(tabs.boards),
              ),
            ),
          );
        },
      ),
    );
  }

  PreferredSize buildAppBar(BuildContext context, Tabs tabs) {
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
              child: BoardTabs(tabs),
              preferredSize: Size.fromHeight(40.0),
            ),
            actions: [
              IconButton(
                onPressed: () {
                  context.read<SearchCubit>().startSearching(context);
                },
                icon: Icon(Icons.search),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.sort),
              ),
            ],
          );
        },
      ),
    );
  }

  TabBarView buildTabBarView(List<Board> boards) {
    return TabBarView(
      children: boards
          .map(
            (board) => ThreadsPage(board),
          )
          .toList(),
    );
  }
}
