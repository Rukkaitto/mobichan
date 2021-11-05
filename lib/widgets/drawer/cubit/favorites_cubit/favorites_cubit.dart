import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobichan_domain/mobichan_domain.dart';
part 'favorites_state.dart';

class FavoritesCubit extends Cubit<FavoritesState> {
  final BoardRepository boardRepository;
  FavoritesCubit(this.boardRepository) : super(FavoritesInitial());

  void getFavorites() async {
    emit(FavoritesLoading());
    List<Board> favorites = await boardRepository.getFavoriteBoards();
    emit(FavoritesLoaded(favorites));
  }
}
