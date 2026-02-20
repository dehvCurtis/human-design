import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
import 'package:supabase_flutter/supabase_flutter.dart' show User, UserAttributes, UserResponse, OAuthProvider;
import 'package:url_launcher/url_launcher.dart' show LaunchMode;

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
      emailRedirectTo: _getRedirectUrl(),
    );
  }

  /// Sign in with Apple (native)
  Future<supabase.AuthResponse> signInWithApple() async {
    final rawNonce = _generateNonce();
    final hashedNonce = sha256.convert(utf8.encode(rawNonce)).toString();

    final credential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      nonce: hashedNonce,
    );

    final idToken = credential.identityToken;
    if (idToken == null) {
      throw const supabase.AuthException('Apple Sign-In failed: no identity token received.');
    }

    return await _client.auth.signInWithIdToken(
      provider: OAuthProvider.apple,
      idToken: idToken,
      nonce: rawNonce,
    );
  }

  /// Generate a cryptographically secure nonce
  String _generateNonce([int length = 32]) {
    const charset = '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)]).join();
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
