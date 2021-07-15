import 'package:dartz/dartz.dart';
import 'package:mobichan/core/use_cases/usecase.dart';
import 'package:mobichan/features/board/domain/repositories/board_repository.dart';

import '../../../../core/error/failure.dart';
import '../entities/board.dart';

class GetAllBoards extends UseCase<List<Board>, NoParams> {
  final BoardRepository repository;

  GetAllBoards(this.repository);

  Future<Either<Failure, List<Board>>> call(NoParams params) async {
    return await repository.getAllBoards();
  }
}
