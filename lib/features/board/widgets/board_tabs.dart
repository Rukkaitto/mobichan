import 'package:flutter/material.dart';
import 'package:mobichan_domain/mobichan_domain.dart';

class BoardTabs extends StatelessWidget {
  final List<Board> favorites;

  const BoardTabs(this.favorites, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TabBar(
      isScrollable: true,
      tabs: favorites
          .map(
            (favorite) => Tab(
              child: Text(favorite.title),
            ),
          )
          .toList(),
    );
  }
}
