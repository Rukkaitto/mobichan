import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobichan_domain/mobichan_domain.dart';

class BoardCubit extends Cubit<Board> {
  final BoardRepository repository;
  BoardCubit({required this.repository}) : super(Board.initial);

  Future<void> getLastVisitedBoard() async {
    final board = await repository.getLastVisitedBoard();
    emit(board);
  }

  Future<void> saveLastVisitedBoard(Board board) async {
    await repository.saveLastVisitedBoard(board);
    emit(board);
  }
}
