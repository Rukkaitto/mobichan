part of 'board_bloc.dart';

abstract class BoardEvent extends Equatable {
  const BoardEvent();
}

class GetAllBoards extends BoardEvent {
  @override
  List<Object?> get props => [];

  const GetAllBoards();
}

class GetBoard extends BoardEvent {
  final String code;

  @override
  List<Object?> get props => [code];

  const GetBoard(this.code);
}
