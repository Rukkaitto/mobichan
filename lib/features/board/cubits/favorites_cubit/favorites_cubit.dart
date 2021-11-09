import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobichan_domain/mobichan_domain.dart';
part 'favorites_state.dart';

class FavoritesCubit extends Cubit<FavoritesState> {
  final BoardRepository repository;
  FavoritesCubit({required this.repository}) : super(FavoritesInitial());

  Future<void> getFavorites() async {
    emit(FavoritesLoading());
    List<Board> favorites = await repository.getFavoriteBoards();
    print(favorites);
    emit(FavoritesLoaded(favorites));
  }
}
