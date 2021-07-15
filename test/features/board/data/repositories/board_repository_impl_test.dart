import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobichan/core/error/exception.dart';
import 'package:mobichan/core/error/failure.dart';
import 'package:mobichan/features/board/data/data_sources/board_local_data_source.dart';
import 'package:mobichan/features/board/data/data_sources/board_remote_data_source.dart';
import 'package:mobichan/features/board/data/models/board_model.dart';
import 'package:mobichan/features/board/data/repositories/board_repository_impl.dart';
import 'package:mobichan/features/board/domain/entities/board.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'board_repository_impl_test.mocks.dart';

@GenerateMocks([BoardRemoteDataSource, BoardLocalDataSource])
void main() {
  late BoardRepositoryImpl repository;
  late MockBoardRemoteDataSource mockBoardRemoteDataSource;
  late MockBoardLocalDataSource mockBoardLocalDataSource;

  setUp(() {
    mockBoardRemoteDataSource = MockBoardRemoteDataSource();
    mockBoardLocalDataSource = MockBoardLocalDataSource();
    repository = BoardRepositoryImpl(
      remoteDataSource: mockBoardRemoteDataSource,
      localDataSource: mockBoardLocalDataSource,
    );
  });

  group('getAllBoards', () {
    final List<BoardModel> tBoardModels = [
      BoardModel(code: 'g', title: 'Technology')
    ];
    final List<Board> tBoards = tBoardModels;

    test(
        'should return remote data when the call to remote data source is successful',
        () async {
      // arrange
      when(mockBoardRemoteDataSource.getAllBoards())
          .thenAnswer((_) async => tBoardModels);
      // act
      final result = await repository.getAllBoards();
      // assert
      verify(mockBoardRemoteDataSource.getAllBoards());
      expect(result, equals(Right(tBoards)));
    });

    test(
        'should return server failure when the call to remote data source is unsuccessful',
        () async {
      // arrange
      when(mockBoardRemoteDataSource.getAllBoards())
          .thenThrow(ServerException());
      // act
      final result = await repository.getAllBoards();
      // assert
      verify(mockBoardRemoteDataSource.getAllBoards());
      verifyZeroInteractions(mockBoardLocalDataSource);
      expect(result, equals(Left(ServerFailure())));
    });
  });

  group('getBoard', () {
    final String tCode = 'g';
    final BoardModel tBoardModel = BoardModel(code: 'g', title: 'Technology');
    final Board tBoard = tBoardModel;

    test(
        'should return remote data when the call to remote data source is successful',
        () async {
      // arrange
      when(mockBoardRemoteDataSource.getBoard(tCode))
          .thenAnswer((_) async => tBoardModel);
      // act
      final result = await repository.getBoard(tCode);
      // assert
      verify(mockBoardRemoteDataSource.getBoard(tCode));
      expect(result, equals(Right(tBoard)));
    });

    test(
      'should cache the data locally when the call to remote data source is successful',
      () async {
        // arrange
        when(mockBoardRemoteDataSource.getBoard(tCode))
            .thenAnswer((_) async => tBoardModel);
        // act
        await repository.getBoard(tCode);
        // assert
        verify(mockBoardRemoteDataSource.getBoard(tCode));
        verify(mockBoardLocalDataSource.cacheBoard(tBoardModel));
      },
    );

    test(
        'should return server failure when the call to remote data source is unsuccessful',
        () async {
      // arrange
      when(mockBoardRemoteDataSource.getBoard(tCode))
          .thenThrow(ServerException());
      // act
      final result = await repository.getBoard(tCode);
      // assert
      verify(mockBoardRemoteDataSource.getBoard(tCode));
      verifyZeroInteractions(mockBoardLocalDataSource);
      expect(result, equals(Left(ServerFailure())));
    });
  });
}
