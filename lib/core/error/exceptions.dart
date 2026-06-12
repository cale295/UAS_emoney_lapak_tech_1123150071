class ServerException implements Exception {
  final String message;
  final String? errorCode;
  final int? statusCode;
  const ServerException(this.message, {this.errorCode, this.statusCode});
}

class NetworkException implements Exception {
  final String message;
  const NetworkException([this.message = 'Tidak ada koneksi internet.']);
}