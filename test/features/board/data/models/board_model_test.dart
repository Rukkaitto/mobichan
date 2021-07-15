import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mobichan/features/board/data/models/board_model.dart';
import 'package:mobichan/features/board/domain/entities/board.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final tBoardModel = BoardModel(code: 'g', title: 'Technology');

  test('should be a subclass of Board entity', () async {
    expect(tBoardModel, isA<Board>());
  });

  group('fromJson', () {
    test(
      'should return a valid model when the board is a regular board',
      () async {
        // arrange
        final Map<String, dynamic> jsonMap = jsonDecode(fixture('board.json'));
        // act
        final result = BoardModel.fromJson(jsonMap);
        // assert
        expect(result, tBoardModel);
      },
    );
  });

  group('toJson', () {
    test('should return a JSON map containing the proper data', () async {
      // act
      final result = tBoardModel.toJson();
      // assert
      final expectedJsonMap = {
        "code": "g",
        "title": "Technology",
      };
      expect(result, expectedJsonMap);
    });
  });
}
