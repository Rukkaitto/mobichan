import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mobichan/localization.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mobichan_domain/mobichan_domain.dart';
part 'boards_state.dart';

class BoardsCubit extends Cubit<BoardsState> {
  final BoardRepository boardRepository;
  late List<Board> boards;

  BoardsCubit(this.boardRepository) : super(BoardsInitial());

  Future<void> getBoards() async {
    try {
      emit(BoardsLoading());
      boards = await boardRepository.getBoards();
      emit(BoardsLoaded(boards));
    } on NetworkException {
      emit(BoardsError(boards_loading_error.tr()));
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

class NetworkException implements Exception {}
