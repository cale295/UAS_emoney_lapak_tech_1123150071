class ServerException implements Exception {
  final String message;
  final String? errorCode;
  final int? statusCode;
  const ServerException(this.message, {this.errorCode, this.statusCode});
}