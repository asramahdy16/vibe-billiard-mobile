import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants/app_constants.dart';

/// Secure token CRUD operations via flutter_secure_storage
class SecureStorageService {
  final FlutterSecureStorage _storage;

  SecureStorageService()
      : _storage = const FlutterSecureStorage(
          aOptions: AndroidOptions(encryptedSharedPreferences: true),
        );

  // ─── Token ────────────────────────────────────────────────
  Future<String?> getToken() async {
    return await _storage.read(key: AppConstants.tokenKey);
  }

  Future<void> saveToken(String token) async {
    await _storage.write(key: AppConstants.tokenKey, value: token);
  }

  Future<void> deleteToken() async {
    await _storage.delete(key: AppConstants.tokenKey);
  }

  // ─── User JSON ────────────────────────────────────────────
  Future<String?> getUserData() async {
    return await _storage.read(key: AppConstants.userKey);
  }

  Future<void> saveUserData(String jsonString) async {
    await _storage.write(key: AppConstants.userKey, value: jsonString);
  }

  Future<void> deleteUserData() async {
    await _storage.delete(key: AppConstants.userKey);
  }

  // ─── Clear all ────────────────────────────────────────────
  Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}

/// Global provider for SecureStorageService
final storageProvider = Provider<SecureStorageService>((ref) {
  return SecureStorageService();
});
