import 'package:flutter/material.dart';
import 'package:mobichan/core/core.dart';
import 'package:mobichan/features/board/board.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BoardTabs extends StatelessWidget {
  const BoardTabs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).cardColor,
      width: double.infinity,
      child: AsyncBlocBuilder<TabsLoadedArgs, TabsCubit, TabsState, TabsLoading,
          TabsLoaded, TabsError>(
        builder: (context, tabs) {
          DefaultTabController.of(context)?.animateTo(tabs.currentIndex);
          return TabBar(
            onTap: (index) async {
              await context.read<TabsCubit>().setCurrentTab(tabs.boards[index]);
              await context.read<FavoritesCubit>().getFavorites();
            },
            isScrollable: true,
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            labelStyle: Theme.of(context).textTheme.headline2,
            unselectedLabelColor: Theme.of(context).disabledColor,
            tabs: tabs.boards
                .map(
                  (favorite) => Tab(text: favorite.title),
                )
                .toList(),
          );
        },
        loadingBuilder: () => Container(),
      ),
    );
  }
}
