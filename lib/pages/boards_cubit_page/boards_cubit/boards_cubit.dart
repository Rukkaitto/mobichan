import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mobichan/api/api.dart';
import 'package:mobichan/classes/models/board.dart';
part 'boards_state.dart';

class BoardsCubit extends Cubit<BoardsState> {
  late List<Board> boards;

  BoardsCubit() : super(BoardsInitial());

  Future<void> getBoards() async {
    try {
      emit(BoardsLoading());
      boards = await Api.fetchBoards();
      emit(BoardsLoaded(boards));
    } on NetworkException {
      emit(BoardsError("Couldn't fetch boards. Is the device online?"));
    }
  }

  void search(String input) {
    if (input == "") {
      emit(BoardsLoaded(boards));
    } else {
      print(boards);
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
