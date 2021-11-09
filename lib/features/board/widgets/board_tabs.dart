import 'package:flutter/material.dart';
import 'package:mobichan_domain/mobichan_domain.dart';

class BoardTabs extends StatelessWidget {
  final List<Board> favorites;

  const BoardTabs(this.favorites, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).cardColor,
      child: Row(
        children: [
          TabBar(
            isScrollable: true,
            labelStyle: Theme.of(context).textTheme.headline2,
            unselectedLabelColor: Theme.of(context).disabledColor,
            tabs: favorites
                .map(
                  (favorite) => Tab(text: favorite.title),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}
