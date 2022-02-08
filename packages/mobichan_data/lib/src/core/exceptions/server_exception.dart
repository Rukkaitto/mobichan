/// Thrown if an error code is returned from the API
class ServerException implements Exception {
  final String? message;
  final int? code;

  ServerException({
    required this.message,
    required this.code,
  });

  @override
  String toString() {
    return 'ServerException: $message (code: $code)';
  }
}
