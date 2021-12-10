import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobichan_domain/mobichan_domain.dart';

class FavoriteCubit extends Cubit<bool> {
  final BoardRepository repository;
  FavoriteCubit({required this.repository}) : super(false);

  Future<void> addToFavorites(Board board) async {
    await repository.addBoardToFavorites(board);
    emit(true);
  }

  Future<void> removeFromFavorites(Board board) async {
    await repository.removeBoardFromFavorites(board);
    emit(false);
  }

  Future<void> checkIfInFavorites(Board board) async {
    bool isInFavorites = await repository.isBoardInFavorites(board);
    emit(isInFavorites);
  }
}
