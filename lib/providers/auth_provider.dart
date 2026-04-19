import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/user_model.dart';
import '../data/repositories/auth_repository.dart';
import '../core/storage/secure_storage_service.dart';

@immutable
class AuthState {
  final UserModel? user;
  final String? token;
  final bool isAuthenticated;
  final bool isLoading;
  final String? errorMessage;
  final bool isInitialCheckDone;

  const AuthState({
    this.user,
    this.token,
    this.isAuthenticated = false,
    this.isLoading = false,
    this.errorMessage,
    this.isInitialCheckDone = false,
  });

  AuthState copyWith({
    UserModel? user,
    String? token,
    bool? isAuthenticated,
    bool? isLoading,
    String? errorMessage,
    bool? isInitialCheckDone,
  }) {
    return AuthState(
      user: user ?? this.user,
      token: token ?? this.token,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      isInitialCheckDone: isInitialCheckDone ?? this.isInitialCheckDone,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _repository;
  final SecureStorageService _storage;

  AuthNotifier(this._repository, this._storage) : super(const AuthState());

  Future<void> checkAuth() async {
    try {
      final token = await _storage.getToken();
      if (token == null) {
        state = state.copyWith(isInitialCheckDone: true);
        return;
      }

      final userStr = await _storage.getUserData();
      UserModel? user;
      if (userStr != null) {
        user = UserModel.fromJson(jsonDecode(userStr));
      }

      // Set authenticated immediately from local storage so the app
      // can navigate without waiting for the network.
      state = state.copyWith(
        token: token,
        user: user,
        isAuthenticated: true,
        isInitialCheckDone: true,
      );

      // Verify and update user from remote in background (non-blocking)
      _refreshUserInBackground();
    } catch (e) {
      // If anything fails, reset to unauthenticated
      state = const AuthState(isInitialCheckDone: true);
    }
  }

  /// Refreshes user data from the server without blocking the UI.
  Future<void> _refreshUserInBackground() async {
    try {
      final updatedUser = await _repository.getMe();
      state = state.copyWith(user: updatedUser);
    } catch (e) {
      // If unauthorized (401), the interceptor already cleared the token.
      // Check if the token was wiped and log the user out.
      final token = await _storage.getToken();
      if (token == null) {
        state = const AuthState(isInitialCheckDone: true);
      }
      // Otherwise silently ignore - user can still use cached data
      debugPrint('Background user refresh failed: $e');
    }
  }

  Future<void> login(String email, String password) async {
    try {
      state = state.copyWith(isLoading: true, errorMessage: null);
      final user = await _repository.login(email: email, password: password);
      final token = await _storage.getToken();
      
      state = state.copyWith(
        isLoading: false,
        isAuthenticated: true,
        user: user,
        token: token,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
      rethrow;
    }
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
    String? phone,
  }) async {
    try {
      state = state.copyWith(isLoading: true, errorMessage: null);
      final user = await _repository.register(
        name: name,
        email: email,
        password: password,
        passwordConfirmation: passwordConfirmation,
        phone: phone,
      );
      final token = await _storage.getToken();
      
      state = state.copyWith(
        isLoading: false,
        isAuthenticated: true,
        user: user,
        token: token,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
      rethrow;
    }
  }

  Future<void> logout() async {
    try {
      state = state.copyWith(isLoading: true);
      await _repository.logout();
    } catch (e) {
      debugPrint('Logout error: $e');
    } finally {
      state = const AuthState(isInitialCheckDone: true);
    }
  }

  Future<void> updateProfile({
    required String name,
    String? phone,
  }) async {
    try {
      state = state.copyWith(isLoading: true, errorMessage: null);
      final user = await _repository.updateProfile(name: name, phone: phone);
      state = state.copyWith(
        isLoading: false,
        user: user,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
      rethrow;
    }
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final repo = ref.read(authRepositoryProvider);
  final storage = ref.read(storageProvider);
  return AuthNotifier(repo, storage);
});
