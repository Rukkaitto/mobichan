import 'package:dartz/dartz.dart';
import 'package:mobichan/features/board/domain/repositories/board_repository.dart';

import '../../../../core/error/failure.dart';
import '../entities/board.dart';

class GetAllBoards {
  final BoardRepository repository;

  GetAllBoards(this.repository);

  Future<Either<Failure, List<Board>>> call() async {
    return await repository.getAllBoards();
  }
}
