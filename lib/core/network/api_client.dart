import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants/api_constants.dart';
import '../storage/secure_storage_service.dart';
import 'api_exceptions.dart';

/// Dio-based HTTP client with token interceptor and error handling
class ApiClient {
  late final Dio _dio;
  final SecureStorageService _storage;

  ApiClient(this._storage) {
    _dio = Dio(BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    // Request Interceptor: Attach Bearer Token
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await _storage.getToken();
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onError: (error, handler) async {
        if (error.response?.statusCode == 401) {
          await _storage.deleteToken();
          await _storage.deleteUserData();
        }
        return handler.next(error);
      },
    ));
  }

  // ─── HTTP Methods ─────────────────────────────────────────
  Future<Response> get(String path, {Map<String, dynamic>? queryParams}) async {
    try {
      return await _dio.get(path, queryParameters: queryParams);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Response> post(String path, {dynamic data}) async {
    try {
      return await _dio.post(path, data: data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Response> put(String path, {dynamic data}) async {
    try {
      return await _dio.put(path, data: data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Response> patch(String path, {dynamic data}) async {
    try {
      return await _dio.patch(path, data: data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Response> delete(String path) async {
    try {
      return await _dio.delete(path);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // ─── Error Handler ────────────────────────────────────────
  ApiException _handleError(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout) {
      return NetworkException(message: 'Koneksi timeout, coba lagi');
    }

    if (e.type == DioExceptionType.connectionError) {
      return NetworkException();
    }

    final response = e.response;
    if (response == null) {
      return NetworkException();
    }

    final data = response.data;
    final message = data is Map ? (data['message'] ?? 'Terjadi kesalahan') : 'Terjadi kesalahan';

    switch (response.statusCode) {
      case 401:
        return UnauthorizedException(message: message);
      case 409:
        return ConflictException(message: message);
      case 422:
        final errors = data is Map && data['errors'] != null
            ? Map<String, List<String>>.from(
                (data['errors'] as Map).map(
                  (key, value) => MapEntry(
                    key.toString(),
                    (value as List).map((e) => e.toString()).toList(),
                  ),
                ),
              )
            : null;
        return ValidationException(message: message, errors: errors);
      case 500:
        return ServerException();
      default:
        return ApiException(message: message, statusCode: response.statusCode);
    }
  }
}

/// Global provider for ApiClient
final apiClientProvider = Provider<ApiClient>((ref) {
  final storage = ref.read(storageProvider);
  return ApiClient(storage);
});
