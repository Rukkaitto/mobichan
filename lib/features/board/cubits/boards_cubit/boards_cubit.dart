import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mobichan/localization.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mobichan_data/mobichan_data.dart';
import 'package:mobichan_domain/mobichan_domain.dart';
part 'boards_state.dart';

class BoardsCubit extends Cubit<BoardsState> {
  final BoardRepository repository;
  late List<Board> boards;

  BoardsCubit({required this.repository}) : super(const BoardsInitial());

  Future<void> getBoards() async {
    try {
      emit(const BoardsLoading());
      boards = await repository.getBoards();
      await repository.insertBoards(boards);
      emit(BoardsLoaded(boards));
    } on NetworkException {
      emit(BoardsError(kBoardsLoadingError.tr()));
    }
  }

  void search(String input) {
    if (input == "") {
      emit(BoardsLoaded(boards));
    } else {
      final filteredBoards = boards
          .where((board) =>
              board.board.contains(input.toLowerCase().trim()) ||
              board.title.toLowerCase().contains(input.toLowerCase().trim()))
          .toList();
      emit(BoardsLoaded(filteredBoards));
    }
  }
}
