import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobichan_data/mobichan_data.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'network_manager_test.mocks.dart';

@GenerateMocks([NetworkInfo, Dio])
void main() {
  late MockNetworkInfo mockNetworkInfo;
  late MockDio mockClient;
  late NetworkManagerImpl networkManager;

  setUp(() {
    mockNetworkInfo = MockNetworkInfo();
    mockClient = MockDio();
    networkManager = NetworkManagerImpl(
      networkInfo: mockNetworkInfo,
      client: mockClient,
    );
  });

  const tUrl = 'https://www.google.com';

  final t200Response = Response(
    data: 'data',
    statusCode: 200,
    requestOptions: RequestOptions(path: tUrl),
  );

  final t400Response = Response(
    data: 'data',
    statusCode: 400,
    requestOptions: RequestOptions(path: tUrl),
  );

  group('makeRequest', () {
    group('has no connection', () {
      test('should throw a NetworkException', () async {
        // arrange
        when(mockNetworkInfo.isConnected)
            .thenAnswer((_) => Future.value(false));

        // act
        final call = networkManager.makeRequest;

        // assert
        expect(
          call(url: tUrl),
          throwsA(isA<NetworkException>()),
        );
      });
    });

    group('has connection', () {
      test('should call the client\'s request method', () async {
        // arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) => Future.value(true));
        when(
          mockClient.request(
            any,
            data: anyNamed('data'),
            options: anyNamed('options'),
          ),
        ).thenAnswer(
          (_) => Future.value(t200Response),
        );

        // act
        await networkManager.makeRequest(url: tUrl);

        // assert
        verify(
          mockClient.request(
            any,
            data: anyNamed('data'),
            options: anyNamed('options'),
          ),
        ).called(1);
      });

      test('should return data if the status code is 200', () async {
        // arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) => Future.value(true));
        when(
          mockClient.request(
            any,
            data: anyNamed('data'),
            options: anyNamed('options'),
          ),
        ).thenAnswer(
          (_) => Future.value(t200Response),
        );

        // act
        final result = await networkManager.makeRequest(url: tUrl);

        // assert
        expect(result, t200Response.data);
      });

      test('should throw a ServerException if the status code isn\'t 200', () {
        // arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) => Future.value(true));

        when(
          mockClient.request(
            any,
            data: anyNamed('data'),
            options: anyNamed('options'),
          ),
        ).thenAnswer((_) => Future.value(t400Response));

        // act
        final call = networkManager.makeRequest;

        // assert
        expect(
          call(url: tUrl),
          throwsA(isA<ServerException>()),
        );
      });
    });
  });
}
