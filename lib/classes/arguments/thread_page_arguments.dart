import 'package:mobichan_domain/mobichan_domain.dart';

class ThreadPageArguments {
  final Board board;
  final Post thread;
  final String title;

  ThreadPageArguments({
    required this.board,
    required this.thread,
    required this.title,
  });
}
