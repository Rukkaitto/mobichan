import 'package:flutter/material.dart';
import 'package:mobichan/features/board/board.dart';
import 'package:mobichan_domain/mobichan_domain.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BoardTabs extends StatelessWidget {
  final Tabs tabs;

  const BoardTabs(this.tabs, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).cardColor,
      width: double.infinity,
      child: BlocBuilder<TabsCubit, Tabs>(
        builder: (context, tabs) {
          DefaultTabController.of(context)
              ?.animateTo(tabs.boards.indexOf(tabs.current));
          return TabBar(
            onTap: (index) async {
              await context.read<TabsCubit>().setCurrentTab(tabs.boards[index]);
            },
            isScrollable: true,
            physics:
                BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            labelStyle: Theme.of(context).textTheme.headline2,
            unselectedLabelColor: Theme.of(context).disabledColor,
            tabs: tabs.boards
                .map(
                  (favorite) => Tab(text: favorite.title),
                )
                .toList(),
          );
        },
      ),
    );
  }
}
