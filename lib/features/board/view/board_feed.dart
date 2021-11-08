import 'package:flutter/material.dart';
import 'package:mobichan_domain/mobichan_domain.dart';

class BoardFeed extends StatelessWidget {
  final Board board;

  const BoardFeed(this.board, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(board.fullTitle),
    );
  }
}
