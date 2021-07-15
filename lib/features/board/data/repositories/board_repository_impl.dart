import 'package:dartz/dartz.dart';
import 'package:mobichan/core/error/exception.dart';
import 'package:mobichan/core/error/failure.dart';
import 'package:mobichan/features/board/data/data_sources/board_local_data_source.dart';
import 'package:mobichan/features/board/data/data_sources/board_remote_data_source.dart';
import 'package:mobichan/features/board/domain/entities/board.dart';
import 'package:mobichan/features/board/domain/repositories/board_repository.dart';

class BoardRepositoryImpl implements BoardRepository {
  final BoardRemoteDataSource remoteDataSource;
  final BoardLocalDataSource localDataSource;

  BoardRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, List<Board>>> getAllBoards() async {
    try {
      final remoteBoards = await remoteDataSource.getAllBoards();
      return Right(remoteBoards);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Board>> getBoard(String code) async {
    try {
      final remoteBoard = await remoteDataSource.getBoard(code);
      localDataSource.cacheBoard(remoteBoard);
      return Right(remoteBoard);
    } on ServerException {
      return Left(ServerFailure());
    }
  }
}
