import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobichan/core/core.dart';
import 'package:mobichan_domain/mobichan_domain.dart';
part 'board_state.dart';

class BoardCubit extends Cubit<BoardState> {
  final BoardRepository repository;
  BoardCubit({required this.repository}) : super(BoardInitial());

  Future<void> getLastVisitedBoard() async {
    final board = await repository.getLastVisitedBoard();
    emit(BoardLoaded(board));
  }

  Future<void> saveLastVisitedBoard(Board board) async {
    await repository.saveLastVisitedBoard(board);
    emit(BoardLoaded(board));
  }
}
