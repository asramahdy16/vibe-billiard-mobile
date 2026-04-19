/// Custom API exceptions
class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic data;

  ApiException({required this.message, this.statusCode, this.data});

  @override
  String toString() => 'ApiException($statusCode): $message';
}

class UnauthorizedException extends ApiException {
  UnauthorizedException({String message = 'Sesi telah berakhir, silakan login kembali'})
      : super(message: message, statusCode: 401);
}

class ValidationException extends ApiException {
  final Map<String, List<String>>? errors;

  ValidationException({
    String message = 'Data tidak valid',
    this.errors,
  }) : super(message: message, statusCode: 422);

  String get firstError {
    if (errors != null && errors!.isNotEmpty) {
      final firstField = errors!.values.first;
      if (firstField.isNotEmpty) return firstField.first;
    }
    return message;
  }
}

class ConflictException extends ApiException {
  ConflictException({String message = 'Jadwal bentrok dengan booking lain'})
      : super(message: message, statusCode: 409);
}

class NetworkException extends ApiException {
  NetworkException({String message = 'Tidak ada koneksi internet'})
      : super(message: message, statusCode: null);
}

class ServerException extends ApiException {
  ServerException({String message = 'Terjadi kesalahan pada server'})
      : super(message: message, statusCode: 500);
}
