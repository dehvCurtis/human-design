import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
import 'package:supabase_flutter/supabase_flutter.dart' show User, UserAttributes, UserResponse, OAuthProvider, LaunchMode;
import 'package:uuid/uuid.dart';

/// Repository for authentication operations
class AuthRepository {
  AuthRepository({required supabase.SupabaseClient supabaseClient})
      : _client = supabaseClient;

  final supabase.SupabaseClient _client;

  /// Pending OAuth state for CSRF protection
  String? _pendingOAuthState;

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
      emailRedirectTo: _getRedirectUrl(),
    );
  }

  /// Sign in with Apple
  ///
  /// Includes CSRF protection via state parameter.
  Future<bool> signInWithApple() async {
    _pendingOAuthState = const Uuid().v4();
    return await _client.auth.signInWithOAuth(
      OAuthProvider.apple,
      redirectTo: _getRedirectUrl(),
      authScreenLaunchMode: LaunchMode.externalApplication,
      queryParams: {'state': _pendingOAuthState!},
    );
  }

  /// Sign in with Google
  ///
  /// Includes CSRF protection via state parameter.
  Future<bool> signInWithGoogle() async {
    _pendingOAuthState = const Uuid().v4();
    return await _client.auth.signInWithOAuth(
      OAuthProvider.google,
      redirectTo: _getRedirectUrl(),
      authScreenLaunchMode: LaunchMode.externalApplication,
      queryParams: {'state': _pendingOAuthState!},
    );
  }

  /// Validate OAuth state parameter (call after OAuth redirect)
  ///
  /// Returns true if state matches, false otherwise.
  /// Always clears the pending state after validation.
  bool validateOAuthState(String? returnedState) {
    final isValid = _pendingOAuthState != null &&
        returnedState != null &&
        _pendingOAuthState == returnedState;
    _pendingOAuthState = null;
    return isValid;
  }

  /// Clear pending OAuth state (call on cancel or error)
  void clearPendingOAuthState() {
    _pendingOAuthState = null;
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

  /// Resend confirmation email for unconfirmed accounts
  Future<void> resendConfirmationEmail(String email) async {
    await _client.auth.resend(
      type: supabase.OtpType.signup,
      email: email,
      emailRedirectTo: _getRedirectUrl(),
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

  /// Export all user data in JSON format (GDPR Article 20 - Right to data portability)
  /// Returns a JSON string containing all user data
  Future<String> exportUserData() async {
    final userId = currentUser?.id;
    if (userId == null) {
      throw StateError('No user logged in');
    }

    final exportData = <String, dynamic>{
      'exportDate': DateTime.now().toIso8601String(),
      'userId': userId,
      'email': currentUser?.email,
    };

    try {
      // Export profile data
      final profile = await _client
          .from('profiles')
          .select()
          .eq('id', userId)
          .maybeSingle();
      if (profile != null) {
        exportData['profile'] = profile;
      }

      // Export charts
      final charts = await _client
          .from('charts')
          .select()
          .eq('user_id', userId);
      exportData['charts'] = charts;

      // Export posts
      final posts = await _client
          .from('posts')
          .select()
          .eq('user_id', userId);
      exportData['posts'] = posts;

      // Export reactions
      final reactions = await _client
          .from('reactions')
          .select()
          .eq('user_id', userId);
      exportData['reactions'] = reactions;

      // Export messages (only sent messages)
      final messages = await _client
          .from('messages')
          .select()
          .eq('sender_id', userId);
      exportData['messages'] = messages;

      // Export stories
      final stories = await _client
          .from('stories')
          .select()
          .eq('user_id', userId);
      exportData['stories'] = stories;

      // Export follows
      final following = await _client
          .from('follows')
          .select()
          .eq('follower_id', userId);
      exportData['following'] = following;

      // Export gamification data
      final points = await _client
          .from('user_points')
          .select()
          .eq('user_id', userId)
          .maybeSingle();
      if (points != null) {
        exportData['points'] = points;
      }

      final badges = await _client
          .from('user_badges')
          .select()
          .eq('user_id', userId);
      exportData['badges'] = badges;

      final challenges = await _client
          .from('user_challenges')
          .select()
          .eq('user_id', userId);
      exportData['challenges'] = challenges;

      // Export quiz attempts
      final quizAttempts = await _client
          .from('quiz_attempts')
          .select()
          .eq('user_id', userId);
      exportData['quizAttempts'] = quizAttempts;

      // Export shares
      final shares = await _client
          .from('shares')
          .select()
          .eq('user_id', userId);
      exportData['shares'] = shares;

    } catch (e) {
      // Some tables may not exist, continue with partial data
      debugPrint('Error exporting some data: $e');
    }

    return const JsonEncoder.withIndent('  ').convert(exportData);
  }

  /// Delete user account and all associated data
  ///
  /// Uses an edge function to perform atomic deletion of all user data.
  /// This is GDPR-compliant and ensures no orphaned data remains.
  ///
  /// The edge function performs all deletions in a transaction:
  /// 1. Deletes all user content (posts, messages, stories, etc.)
  /// 2. Deletes user profile and settings
  /// 3. Deletes the auth user
  ///
  /// If any step fails, the entire operation is rolled back.
  Future<void> deleteAccount() async {
    final userId = currentUser?.id;
    if (userId == null) {
      throw StateError('No user logged in');
    }

    try {
      // Use edge function for atomic deletion
      // The edge function handles all data deletion in a single transaction
      // to prevent orphaned data if any step fails
      final response = await _client.functions.invoke(
        'delete-user-cascade',
        body: {'userId': userId},
      );

      if (response.status != 200) {
        final error = response.data?['error'] ?? 'Unknown error';
        throw StateError('Failed to delete account: $error');
      }
    } catch (e) {
      // Ensure user is signed out even on failure
      await signOut();
      rethrow;
    }

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
