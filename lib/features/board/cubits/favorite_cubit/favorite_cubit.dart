import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobichan_domain/mobichan_domain.dart';

class FavoriteCubit extends Cubit<bool> {
  final BoardRepository repository;
  FavoriteCubit({required this.repository}) : super(false);

  void addToFavorites(Board board) {
    repository.addBoardToFavorites(board);
    emit(true);
  }

  void removeFromFavorites(Board board) {
    repository.removeBoardFromFavorites(board);
    emit(false);
  }

  void checkIfInFavorites(Board board) async {
    bool isInFavorites = await repository.isBoardInFavorites(board);
    emit(isInFavorites);
  }
}
