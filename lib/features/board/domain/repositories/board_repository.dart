import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../entities/board.dart';

abstract class BoardRepository {
  Future<Either<Failure, List<Board>>> getAllBoards();
  Future<Either<Failure, List<Board>>> getFilteredBoards(String searchQuery);
}
