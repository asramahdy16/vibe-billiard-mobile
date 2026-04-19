import 'dart:convert';
import '../models/user_model.dart';
import '../../core/network/api_client.dart';
import '../../core/constants/api_constants.dart';
import '../../core/storage/secure_storage_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthRepository {
  final ApiClient _apiClient;
  final SecureStorageService _storage;

  AuthRepository(this._apiClient, this._storage);

  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
    String? phone,
  }) async {
    final response = await _apiClient.post(
      ApiConstants.register,
      data: {
        'name': name,
        'email': email,
        'password': password,
        'password_confirmation': passwordConfirmation,
        if (phone != null && phone.isNotEmpty) 'phone': phone,
      },
    );

    final data = response.data['data'] ?? response.data;
    final user = UserModel.fromJson(data['user']);
    final token = data['token'];

    await _storage.saveToken(token);
    await _storage.saveUserData(jsonEncode(user.toJson()));

    return user;
  }

  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    final response = await _apiClient.post(
      ApiConstants.login,
      data: {
        'email': email,
        'password': password,
      },
    );

    final data = response.data['data'] ?? response.data;
    final user = UserModel.fromJson(data['user']);
    final token = data['token'];

    await _storage.saveToken(token);
    await _storage.saveUserData(jsonEncode(user.toJson()));

    return user;
  }

  Future<void> logout() async {
    try {
      await _apiClient.post(ApiConstants.logout);
    } finally {
      await _storage.deleteToken();
      await _storage.deleteUserData();
    }
  }

  Future<UserModel> getMe() async {
    final response = await _apiClient.get(ApiConstants.user);
    final data = response.data['data'] ?? response.data;
    final user = UserModel.fromJson(data['user'] ?? data);
    await _storage.saveUserData(jsonEncode(user.toJson()));
    return user;
  }

  Future<UserModel> updateProfile({
    required String name,
    String? phone,
  }) async {
    final response = await _apiClient.put(
      ApiConstants.userProfile,
      data: {
        'name': name,
        if (phone != null) 'phone': phone,
      },
    );

    final data = response.data['data'] ?? response.data;
    final user = UserModel.fromJson(data['user'] ?? data);
    await _storage.saveUserData(jsonEncode(user.toJson()));
    return user;
  }

  Future<void> updatePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    await _apiClient.put(
      ApiConstants.userPassword,
      data: {
        'current_password': currentPassword,
        'password': newPassword,
        'password_confirmation': confirmPassword,
      },
    );
  }
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final apiClient = ref.read(apiClientProvider);
  final storage = ref.read(storageProvider);
  return AuthRepository(apiClient, storage);
});
