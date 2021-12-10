part of 'board_cubit.dart';

abstract class BoardState extends Equatable {
  const BoardState();

  @override
  List<Object> get props => [];
}

class BoardInitial extends BoardState {}

class BoardLoaded extends BoardState {
  final Board board;

  const BoardLoaded(this.board);

  @override
  List<Object> get props => [board];
}
