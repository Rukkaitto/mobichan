import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobichan/classes/models/board.dart';
import 'package:mobichan/utils/utils.dart';

class FavoriteCubit extends Cubit<bool> {
  FavoriteCubit() : super(false);

  void addToFavorites(Board board) {
    Utils.addBoardToFavorites(board);
    emit(true);
  }

  void removeFromFavorites(Board board) {
    Utils.removeBoardFromFavorites(board);
    emit(false);
  }

  void checkIfInFavorites(Board board) async {
    bool isInFavorites = await Utils.isBoardInFavorites(board);
    emit(isInFavorites);
  }
}
