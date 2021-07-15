import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobichan/features/board/domain/entities/board.dart';
import 'package:mobichan/features/board/domain/repositories/board_repository.dart';
import 'package:mobichan/features/board/domain/use_cases/get_board.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_board_test.mocks.dart';

@GenerateMocks([BoardRepository])
void main() {
  late GetBoard usecase;
  late MockBoardRepository mockBoardRepository;

  setUp(() {
    mockBoardRepository = MockBoardRepository();
    usecase = GetBoard(mockBoardRepository);
  });

  final tCode = 'g';
  final tBoard = Board(code: 'g', title: 'Technology');

  test(
    'should get a board from a code from the repository',
    () async {
      when(mockBoardRepository.getBoard(tCode))
          .thenAnswer((_) async => Right(tBoard));

      final result = await usecase(Params(code: tCode));

      expect(result, Right(tBoard));

      verify(mockBoardRepository.getBoard(tCode));

      verifyNoMoreInteractions(mockBoardRepository);
    },
  );
}
