import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobichan_data/mobichan_data.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'network_info_test.mocks.dart';

@GenerateMocks([DataConnectionChecker])
void main() {
  late MockDataConnectionChecker mockConnectionChecker;
  late NetworkInfoImpl networkInfo;

  setUp(() {
    mockConnectionChecker = MockDataConnectionChecker();
    networkInfo = NetworkInfoImpl(
      connectionChecker: mockConnectionChecker,
    );
  });

  group('isConnected', () {
    test('should return true if there is a connection', () async {
      // arrange
      when(mockConnectionChecker.hasConnection)
          .thenAnswer((_) => Future.value(true));

      // act
      final result = await networkInfo.isConnected;

      // assert
      expect(result, true);
    });

    test('should return false if there is no connection', () async {
      // arrange
      when(mockConnectionChecker.hasConnection)
          .thenAnswer((_) => Future.value(false));

      // act
      final result = await networkInfo.isConnected;

      // assert
      expect(result, false);
    });
  });
}
