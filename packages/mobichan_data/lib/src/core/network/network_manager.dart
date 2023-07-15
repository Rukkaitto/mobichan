import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:mobichan_data/mobichan_data.dart';

abstract class NetworkManager {
  Future<T> makeRequest<T>({
    required String url,
    String method,
    dynamic data,
    Map<String, dynamic>? headers,
  });
}

class NetworkManagerImpl implements NetworkManager {
  final NetworkInfo networkInfo;
  final Dio client;
  final Logger logger;

  NetworkManagerImpl({required this.networkInfo, required this.client, required this.logger});

  @override
  Future<T> makeRequest<T>({
    required String url,
    String method = 'GET',
    dynamic data,
    Map<String, dynamic>? headers,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await client.request(
            url,
            data: data,
            options: Options(
              method: method,
              headers: headers,
              ),
            );

        if (response.statusCode == 200) {
          return response.data as T;
        } else {
          logger.e(response.statusCode, response.data);
          throw ServerException(
            message: response.data,
            code: response.statusCode,
          );
        }
      } on DioError catch (e) {
        logger.e(e.response?.statusCode, e.response?.data);
        throw ServerException(
          message: e.response?.data,
          code: e.response?.statusCode,
        );
      }
    } else {
      throw NetworkException();
    }
  }
}
