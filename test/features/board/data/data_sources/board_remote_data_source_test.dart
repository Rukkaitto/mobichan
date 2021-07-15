import 'dart:convert';
import 'dart:core';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mobichan/core/error/exception.dart';
import 'package:mobichan/features/board/data/data_sources/board_remote_data_source.dart';
import 'package:mobichan/features/board/data/models/board_model.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../../fixtures/fixture_reader.dart';
import 'board_remote_data_source_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  late BoardRemoteDataSourceImpl dataSource;
  late MockClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockClient();
    dataSource = BoardRemoteDataSourceImpl(client: mockHttpClient);
  });

  void setUpMockHttpClientSuccess200() {
    when(mockHttpClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response(fixture('boards.json'), 200));
  }

  void setUpMockHttpClientFailure404() {
    when(mockHttpClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response('error message', 404));
  }

  group('getAllBoards', () {
    final Iterable l = jsonDecode(fixture('boards.json'))['boards'];
    final List<BoardModel> tBoardModels =
        List<BoardModel>.from(l.map((json) => BoardModel.fromJson(json)));

    test(
      'should perform a GET request on a URL with /boards being the endpoint and with application/json header',
      () async {
        // arrange
        setUpMockHttpClientSuccess200();
        // act
        dataSource.getAllBoards();
        // assert
        verify(mockHttpClient.get(
          Uri.parse('https://a.4cdn.org/boards.json'),
          headers: {
            'Content-Type': 'application/json',
          },
        ));
      },
    );

    test(
      'should return List<Board> when the reponse code is 200 (success)',
      () async {
        // arrange
        setUpMockHttpClientSuccess200();
        // act
        final result = await dataSource.getAllBoards();
        // assert
        expect(result, equals(tBoardModels));
      },
    );

    test(
      'should throw a ServerException when the response code is 404 or other',
      () async {
        // arrange
        setUpMockHttpClientFailure404();
        // act
        final call = dataSource.getAllBoards;
        // assert
        expect(() => call(), throwsA(TypeMatcher<ServerException>()));
      },
    );
  });

  group('getBoard', () {
    final tCode = 'a';
    final Iterable l = jsonDecode(fixture('boards.json'))['boards'];
    final BoardModel tBoardModel =
        List<BoardModel>.from(l.map((json) => BoardModel.fromJson(json)))
            .firstWhere((element) => element.code == tCode);

    test(
      'should perform a GET request on a URL with /boards being the endpoint and with application/json header',
      () async {
        // arrange
        setUpMockHttpClientSuccess200();
        // act
        dataSource.getBoard(tCode);
        // assert
        verify(mockHttpClient.get(
          Uri.parse('https://a.4cdn.org/boards.json'),
          headers: {
            'Content-Type': 'application/json',
          },
        ));
      },
    );

    test(
      'should return a board when the reponse code is 200 (success)',
      () async {
        // arrange
        setUpMockHttpClientSuccess200();
        // act
        final result = await dataSource.getBoard(tCode);
        // assert
        expect(result, equals(tBoardModel));
      },
    );

    test(
      'should throw a ServerException when the response code is 404 or other',
      () async {
        // arrange
        setUpMockHttpClientFailure404();
        // act
        final call = dataSource.getBoard;
        // assert
        expect(() => call(tCode), throwsA(TypeMatcher<ServerException>()));
      },
    );
  });
}
