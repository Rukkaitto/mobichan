import 'package:board_repository/board_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavoriteCubit extends Cubit<bool> {
  final BoardRepository boardRepository;
  FavoriteCubit(this.boardRepository) : super(false);

  void addToFavorites(Board board) {
    boardRepository.addBoardToFavorites(board);
    emit(true);
  }

  void removeFromFavorites(Board board) {
    boardRepository.removeBoardFromFavorites(board);
    emit(false);
  }

  void checkIfInFavorites(Board board) async {
    bool isInFavorites = await boardRepository.isBoardInFavorites(board);
    emit(isInFavorites);
  }
}
