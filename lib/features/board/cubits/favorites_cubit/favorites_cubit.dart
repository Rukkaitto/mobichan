import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobichan_domain/mobichan_domain.dart';
part 'favorites_state.dart';

class FavoritesCubit extends Cubit<FavoritesState> {
  final BoardRepository repository;
  FavoritesCubit({required this.repository}) : super(const FavoritesInitial());

  Future<void> getFavorites() async {
    emit(const FavoritesLoading());
    List<Board> favorites = await repository.getFavoriteBoards();
    emit(FavoritesLoaded(favorites));
  }

  Future<void> addToFavorites(Board board) async {
    await repository.addBoardToFavorites(board);
    List<Board> favorites = await repository.getFavoriteBoards();
    emit(FavoritesLoaded(favorites));
  }

  Future<void> removeFromFavorites(Board board) async {
    await repository.removeBoardFromFavorites(board);
    List<Board> favorites = await repository.getFavoriteBoards();
    emit(FavoritesLoaded(favorites));
  }
}
