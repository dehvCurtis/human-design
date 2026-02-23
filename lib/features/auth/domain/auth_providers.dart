import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

import '../../../shared/providers/supabase_provider.dart';
import '../data/auth_repository.dart';
import 'auth_errors.dart';

/// Provider for the auth repository
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return AuthRepository(supabaseClient: client);
});

/// Provider for auth state changes (Supabase auth state)
final authStateChangesProvider = StreamProvider<supabase.AuthState>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return repository.authStateChanges;
});

/// Provider for current auth status
final authStatusProvider = Provider<AuthStatus>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  final authState = ref.watch(authStateChangesProvider);

  return authState.when(
    data: (state) {
      if (state.session != null) {
        return AuthStatus.authenticated;
      }
      return AuthStatus.unauthenticated;
    },
    loading: () {
      // Check current session while stream is loading
      if (repository.isAuthenticated) {
        return AuthStatus.authenticated;
      }
      return AuthStatus.unauthenticated;
    },
    error: (_, _) => AuthStatus.error,
  );
});

/// Notifier for handling auth actions
class AuthNotifier extends Notifier<AppAuthState> {
  @override
  AppAuthState build() {
    final repository = ref.watch(authRepositoryProvider);
    final user = repository.currentUser;
    if (user != null) {
      return AppAuthState.authenticated(user);
    }
    return AppAuthState.unauthenticated();
  }

  AuthRepository get _repository => ref.read(authRepositoryProvider);

  Future<void> signInWithEmail({
    required String email,
    required String password,
  }) async {
    state = AppAuthState.loading();
    try {
      final response = await _repository.signInWithEmail(
        email: email,
        password: password,
      );
      if (response.user != null) {
        state = AppAuthState.authenticated(response.user!);
      } else {
        state = AppAuthState.error('Sign in failed. Please try again.');
      }
    } catch (e) {
      state = AppAuthState.error(AuthErrorMessages.fromException(e));
    }
  }

  Future<void> signUpWithEmail({
    required String email,
    required String password,
    String? name,
  }) async {
    state = AppAuthState.loading();
    try {
      final response = await _repository.signUpWithEmail(
        email: email,
        password: password,
        metadata: name != null ? {'name': name} : null,
      );
      if (response.user != null) {
        // Note: User might need to confirm email before fully authenticated
        state = AppAuthState.authenticated(response.user!);
      } else {
        state = AppAuthState.error('Sign up failed. Please try again.');
      }
    } catch (e) {
      state = AppAuthState.error(AuthErrorMessages.fromException(e));
    }
  }

  Future<void> signInWithApple() async {
    state = AppAuthState.loading();
    try {
      final response = await _repository.signInWithApple();
      if (response.user != null) {
        state = AppAuthState.authenticated(response.user!);
      } else {
        state = AppAuthState.error('Apple sign in failed. Please try again.');
      }
    } catch (e, stackTrace) {
      // User cancelled the Apple Sign In dialog — not an error
      if (AuthErrorMessages.isAppleSignInCancelled(e)) {
        state = AppAuthState.unauthenticated();
        return;
      }
      debugPrint('Apple sign-in error: $e');
      debugPrint('Stack trace: $stackTrace');
      state = AppAuthState.error(AuthErrorMessages.fromException(e));
    }
  }

  Future<void> signInWithGoogle() async {
    await _signInWithBrowserOAuth(() => _repository.signInWithGoogle());
  }

  Future<void> signInWithMicrosoft() async {
    await _signInWithBrowserOAuth(() => _repository.signInWithMicrosoft());
  }

  Future<void> signInWithFacebook() async {
    await _signInWithBrowserOAuth(() => _repository.signInWithFacebook());
  }

  /// Shared handler for browser-based OAuth flows (Google, Microsoft, Facebook).
  /// Starts a 30-second timer that resets loading state if the auth listener
  /// hasn't fired (e.g. user closed the browser without completing sign-in).
  Future<void> _signInWithBrowserOAuth(Future<bool> Function() oauthCall) async {
    state = AppAuthState.loading();
    try {
      await oauthCall();
      // Start a timeout: if the auth state hasn't changed to authenticated
      // after 30 seconds, reset to unauthenticated (user likely cancelled).
      Timer(const Duration(seconds: 30), () {
        if (state.status == AuthStatus.loading) {
          state = AppAuthState.unauthenticated();
        }
      });
    } catch (e) {
      state = AppAuthState.error(AuthErrorMessages.fromException(e));
    }
  }

  Future<void> signOut() async {
    state = AppAuthState.loading();
    try {
      await _repository.signOut();
      state = AppAuthState.unauthenticated();
    } catch (e) {
      state = AppAuthState.error(AuthErrorMessages.fromException(e));
    }
  }

  Future<void> sendPasswordReset(String email) async {
    try {
      await _repository.sendPasswordResetEmail(email);
    } catch (e) {
      state = AppAuthState.error(AuthErrorMessages.fromException(e));
    }
  }

  /// Resend confirmation email for unconfirmed accounts
  Future<void> resendConfirmationEmail(String email) async {
    try {
      await _repository.resendConfirmationEmail(email);
    } catch (e) {
      state = AppAuthState.error(AuthErrorMessages.fromException(e));
    }
  }

  void clearError() {
    if (state.status == AuthStatus.error) {
      state = AppAuthState.unauthenticated();
    }
  }
}

/// Provider for the auth notifier
final authNotifierProvider =
    NotifierProvider<AuthNotifier, AppAuthState>(AuthNotifier.new);
