part of 'favorites_cubit.dart';

abstract class FavoritesState extends Equatable {
  const FavoritesState();
}

class FavoritesInitial extends FavoritesState {
  const FavoritesInitial();

  @override
  List<Object?> get props => [];
}

class FavoritesLoading extends FavoritesState {
  const FavoritesLoading();

  @override
  List<Object?> get props => [];
}

class FavoritesLoaded extends FavoritesState {
  final List<Board> favorites;
  const FavoritesLoaded(this.favorites);

  @override
  List<Object?> get props => [favorites];
}

class FavoritesError extends FavoritesState {
  final String message;
  const FavoritesError(this.message);

  @override
  List<Object?> get props => [message];
}
