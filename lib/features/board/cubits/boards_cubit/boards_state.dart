part of 'boards_cubit.dart';

abstract class BoardsState extends Equatable {
  const BoardsState();
}

class BoardsInitial extends BoardsState {
  const BoardsInitial();

  @override
  List<Object?> get props => [];
}

class BoardsLoading extends BoardsState {
  const BoardsLoading();

  @override
  List<Object?> get props => [];
}

class BoardsLoaded extends BoardsState {
  final List<Board> boards;
  const BoardsLoaded(this.boards);

  @override
  List<Object?> get props => [boards];
}

class BoardsError extends BoardsState {
  final String message;
  const BoardsError(this.message);

  @override
  List<Object?> get props => [message];
}
