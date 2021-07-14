import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobichan/features/board/domain/entities/board.dart';
import 'package:mobichan/features/board/domain/repositories/board_repository.dart';
import 'package:mobichan/features/board/domain/use_cases/get_all_boards.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_all_boards_test.mocks.dart';

@GenerateMocks([BoardRepository])
void main() {
  late GetAllBoards usecase;
  late MockBoardRepository mockBoardRepository;

  setUp(() {
    mockBoardRepository = MockBoardRepository();
    usecase = GetAllBoards(mockBoardRepository);
  });

  final tBoards = [Board(code: 'g', title: 'Technology')];

  test(
    'should get all boards from the repository',
    () async {
      when(mockBoardRepository.getAllBoards())
          .thenAnswer((_) async => Right(tBoards));

      final result = await usecase();

      expect(result, Right(tBoards));

      verify(mockBoardRepository.getAllBoards());

      verifyNoMoreInteractions(mockBoardRepository);
    },
  );
}
