part of 'boards_cubit.dart';

abstract class BoardsState {
  const BoardsState();
}

class BoardsInitial extends BoardsState {
  const BoardsInitial();
}

class BoardsLoading extends BoardsState {
  const BoardsLoading();
}

class BoardsLoaded extends BoardsState {
  final List<Board> boards;
  const BoardsLoaded(this.boards);

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is BoardsLoaded && o.boards == boards;
  }

  @override
  int get hashCode => boards.hashCode;
}

class BoardsError extends BoardsState {
  final String message;
  const BoardsError(this.message);

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is BoardsError && o.message == message;
  }

  @override
  int get hashCode => message.hashCode;
}
