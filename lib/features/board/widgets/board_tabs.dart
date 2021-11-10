import 'package:flutter/material.dart';
import 'package:mobichan/features/board/board.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BoardTabs extends StatelessWidget {
  const BoardTabs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).cardColor,
      width: double.infinity,
      child: BlocBuilder<TabsCubit, TabsState>(
        builder: (context, state) {
          if (state is TabsLoaded) {
            DefaultTabController.of(context)
                ?.animateTo(state.boards.indexOf(state.current));
            return TabBar(
              onTap: (index) async {
                await context
                    .read<TabsCubit>()
                    .setCurrentTab(state.boards[index]);
              },
              isScrollable: true,
              physics: BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
              labelStyle: Theme.of(context).textTheme.headline2,
              unselectedLabelColor: Theme.of(context).disabledColor,
              tabs: state.boards
                  .map(
                    (favorite) => Tab(text: favorite.title),
                  )
                  .toList(),
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
