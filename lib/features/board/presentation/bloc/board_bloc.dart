import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mobichan/features/board/domain/entities/board.dart';

part 'board_event.dart';
part 'board_state.dart';

class BoardBloc extends Bloc<BoardEvent, BoardState> {
  BoardBloc() : super(Empty());

  @override
  Stream<BoardState> mapEventToState(
    BoardEvent event,
  ) async* {}
}
