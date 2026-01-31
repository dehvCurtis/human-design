import 'dart:convert';
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
      emailRedirectTo: _getRedirectUrl(),
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
  /// This is a GDPR-compliant full data deletion
  Future<void> deleteAccount() async {
    final userId = currentUser?.id;
    if (userId == null) {
      throw StateError('No user logged in');
    }

    // Delete user data from all tables in order (respecting foreign keys)
    // Note: If you have RLS policies, you may need to use service role or edge functions
    try {
      // Delete user's messages
      await _client.from('messages').delete().eq('sender_id', userId);

      // Delete user's conversations (as participant)
      await _client.from('conversation_participants').delete().eq('user_id', userId);

      // Delete user's posts
      await _client.from('posts').delete().eq('user_id', userId);

      // Delete user's reactions
      await _client.from('reactions').delete().eq('user_id', userId);

      // Delete user's stories
      await _client.from('stories').delete().eq('user_id', userId);

      // Delete user's charts
      await _client.from('charts').delete().eq('user_id', userId);

      // Delete user's shares
      await _client.from('shares').delete().eq('user_id', userId);

      // Delete user's social connections (friends, follows)
      await _client.from('follows').delete().eq('follower_id', userId);
      await _client.from('follows').delete().eq('following_id', userId);

      // Delete user's gamification data
      await _client.from('user_points').delete().eq('user_id', userId);
      await _client.from('user_badges').delete().eq('user_id', userId);
      await _client.from('user_challenges').delete().eq('user_id', userId);
      await _client.from('quiz_attempts').delete().eq('user_id', userId);

      // Delete user's notification preferences
      await _client.from('notification_preferences').delete().eq('user_id', userId);

      // Delete user's profile (this should be last before auth deletion)
      await _client.from('profiles').delete().eq('id', userId);

      // Finally, delete the auth user via edge function (requires service role)
      // The edge function should call supabase.auth.admin.deleteUser(userId)
      await _client.functions.invoke('delete-user');
    } catch (e) {
      // If edge function fails, still sign out but rethrow
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
