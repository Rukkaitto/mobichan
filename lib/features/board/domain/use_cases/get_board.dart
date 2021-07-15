import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:mobichan/core/error/failure.dart';
import 'package:mobichan/core/use_cases/usecase.dart';
import 'package:mobichan/features/board/domain/entities/board.dart';
import 'package:mobichan/features/board/domain/repositories/board_repository.dart';

class GetBoard extends UseCase<Board, Params> {
  final BoardRepository repository;

  GetBoard(this.repository);

  @override
  Future<Either<Failure, Board>> call(Params params) async {
    return await repository.getBoard(params.code);
  }
}

class Params extends Equatable {
  final String code;

  Params({required this.code});

  @override
  List<Object?> get props => [code];
}
