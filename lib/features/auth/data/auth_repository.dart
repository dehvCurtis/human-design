import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
import 'package:supabase_flutter/supabase_flutter.dart' show User, UserAttributes, UserResponse, OAuthProvider, LaunchMode;

/// Repository for authentication operations
class AuthRepository {
  AuthRepository({required supabase.SupabaseClient supabaseClient})
      : _client = supabaseClient;

  final supabase.SupabaseClient _client;

  /// Get the current user
  User? get currentUser => _client.auth.currentUser;

  /// Check if user is authenticated
  bool get isAuthenticated => currentUser != null;

  /// Sign in with email and password
  Future<supabase.AuthResponse> signInWithEmail({
    required String email,
    required String password,
  }) async {
    return await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  /// Sign up with email and password
  Future<supabase.AuthResponse> signUpWithEmail({
    required String email,
    required String password,
    Map<String, dynamic>? metadata,
  }) async {
    return await _client.auth.signUp(
      email: email,
      password: password,
      data: metadata,
    );
  }

  /// Sign in with Apple
  Future<bool> signInWithApple() async {
    return await _client.auth.signInWithOAuth(
      OAuthProvider.apple,
      redirectTo: _getRedirectUrl(),
      authScreenLaunchMode: LaunchMode.externalApplication,
    );
  }

  /// Sign in with Google
  Future<bool> signInWithGoogle() async {
    return await _client.auth.signInWithOAuth(
      OAuthProvider.google,
      redirectTo: _getRedirectUrl(),
      authScreenLaunchMode: LaunchMode.externalApplication,
    );
  }

  /// Sign out
  Future<void> signOut() async {
    await _client.auth.signOut();
  }

  /// Send password reset email
  Future<void> sendPasswordResetEmail(String email) async {
    await _client.auth.resetPasswordForEmail(
      email,
      redirectTo: _getRedirectUrl(),
    );
  }

  /// Update user password
  Future<UserResponse> updatePassword(String newPassword) async {
    return await _client.auth.updateUser(
      UserAttributes(password: newPassword),
    );
  }

  /// Update user metadata
  Future<UserResponse> updateUserMetadata(Map<String, dynamic> metadata) async {
    return await _client.auth.updateUser(
      UserAttributes(data: metadata),
    );
  }

  /// Delete user account
  Future<void> deleteAccount() async {
    // Call edge function to delete user data and account
    await _client.functions.invoke('delete-user');
    await signOut();
  }

  /// Stream of auth state changes
  Stream<supabase.AuthState> get authStateChanges => _client.auth.onAuthStateChange;

  /// Get redirect URL based on platform
  String _getRedirectUrl() {
    if (kIsWeb) {
      return '${Uri.base.origin}/auth/callback';
    }
    if (Platform.isIOS || Platform.isMacOS) {
      return 'io.humandesign.app://auth/callback';
    }
    if (Platform.isAndroid) {
      return 'io.humandesign.app://auth/callback';
    }
    return 'http://localhost:3000/auth/callback';
  }
}

/// Auth state for the application
enum AuthStatus {
  initial,
  authenticated,
  unauthenticated,
  loading,
  error,
}

/// App auth state with user and status
class AppAuthState {
  const AppAuthState({
    this.status = AuthStatus.initial,
    this.user,
    this.errorMessage,
  });

  final AuthStatus status;
  final User? user;
  final String? errorMessage;

  AppAuthState copyWith({
    AuthStatus? status,
    User? user,
    String? errorMessage,
  }) {
    return AppAuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      errorMessage: errorMessage,
    );
  }

  factory AppAuthState.initial() => const AppAuthState();

  factory AppAuthState.authenticated(User user) => AppAuthState(
        status: AuthStatus.authenticated,
        user: user,
      );

  factory AppAuthState.unauthenticated() => const AppAuthState(
        status: AuthStatus.unauthenticated,
      );

  factory AppAuthState.loading() => const AppAuthState(
        status: AuthStatus.loading,
      );

  factory AppAuthState.error(String message) => AppAuthState(
        status: AuthStatus.error,
        errorMessage: message,
      );
}
