part of 'board_bloc.dart';

abstract class BoardState extends Equatable {
  const BoardState();
}

class Empty extends BoardState {
  @override
  List<Object> get props => [];
}

class Loading extends BoardState {
  @override
  List<Object> get props => [];
}

class Loaded extends BoardState {
  final Board board;

  @override
  List<Object> get props => [board];

  Loaded({required this.board});
}

class Error extends BoardState {
  final String message;

  @override
  List<Object> get props => [message];

  Error({required this.message});
}
