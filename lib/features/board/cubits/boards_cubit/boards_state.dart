part of 'boards_cubit.dart';

class BoardsState extends BaseState {}

class BoardsInitial extends BaseInitialState with BoardsState {}

class BoardsLoading extends BaseLoadingState with BoardsState {}

class BoardsLoaded extends BaseLoadedState<List<Board>> with BoardsState {
  BoardsLoaded(List<Board> data) : super(data);
}

class BoardsError extends BaseErrorState with BoardsState {
  BoardsError(String message) : super(message);
}
