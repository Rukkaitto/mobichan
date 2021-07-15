import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mobichan/core/error/exception.dart';
import 'package:mobichan/features/board/data/data_sources/board_local_data_source.dart';
import 'package:mobichan/features/board/data/models/board_model.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../fixtures/fixture_reader.dart';
import 'board_local_data_source_test.mocks.dart';

@GenerateMocks([SharedPreferences])
void main() {
  late BoardLocalDataSourceImpl dataSource;
  late MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSource =
        BoardLocalDataSourceImpl(sharedPreferences: mockSharedPreferences);
  });

  group('getLastBoard', () {
    final tBoardModel =
        BoardModel.fromJson(jsonDecode(fixture('board_cached.json')));

    test(
      'should return Board from SharedPreferences when there is one in the cache',
      () async {
        // arrange
        when(mockSharedPreferences.getString(any))
            .thenReturn(fixture('board_cached.json'));
        // act
        final result = await dataSource.getLastBoard();
        // assert
        verify(mockSharedPreferences.getString('CACHED_BOARD'));
        expect(result, equals(tBoardModel));
      },
    );

    test(
      'should throw a CacheException when there is not a cached value',
      () async {
        // arrange
        when(mockSharedPreferences.getString(any)).thenReturn(null);
        // act
        final call = dataSource.getLastBoard;
        // assert
        expect(() => call(), throwsA(TypeMatcher<CacheException>()));
      },
    );
  });

  group('cacheBoard', () {
    final tBoardModel = BoardModel(code: 'g', title: 'Technology');

    test(
      'should call SharedPreferences to cache the data',
      () async {
        // arrange
        when(mockSharedPreferences.setString(any, any))
            .thenAnswer((_) async => true);

        // act
        dataSource.cacheBoard(tBoardModel);

        // assert
        final expectedJsonString = jsonEncode(tBoardModel.toJson());
        verify(
          mockSharedPreferences.setString('CACHED_BOARD', expectedJsonString),
        );
      },
    );
  });
}
