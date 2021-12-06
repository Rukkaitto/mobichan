part of 'board_cubit.dart';

class BoardState extends BaseState {}

class BoardInitial extends BaseInitialState with BoardState {}

class BoardLoading extends BaseLoadingState with BoardState {}

class BoardLoaded extends BaseLoadedState<Board> with BoardState {
  BoardLoaded(Board data) : super(data);
}

class BoardError extends BaseErrorState with BoardState {
  BoardError(String message) : super(message);
}
