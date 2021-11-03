import 'package:bloc/bloc.dart';
import 'package:mobichan/api/api.dart';
import 'package:mobichan/classes/models/board.dart';
part 'boards_state.dart';

class BoardsCubit extends Cubit<BoardsState> {
  BoardsCubit() : super(BoardsInitial());

  Future<void> getBoards() async {
    try {
      emit(BoardsLoading());
      final boards = await Api.fetchBoards();
      emit(BoardsLoaded(boards));
    } on NetworkException {
      emit(BoardsError("Couldn't fetch boards. Is the device online?"));
    }
  }
}

class NetworkException implements Exception {}
