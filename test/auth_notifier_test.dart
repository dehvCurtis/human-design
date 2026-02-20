import 'package:flutter_test/flutter_test.dart';
import 'package:human_design/features/auth/data/auth_repository.dart';
import 'package:human_design/features/auth/domain/auth_errors.dart';

// ---------------------------------------------------------------------------
// NOTE: AuthNotifier itself is not instantiated here because it depends on
// Riverpod's `ref` and the supabaseClientProvider, which would require a live
// Supabase connection.  Instead, this file tests:
//
//  1. AppAuthState – the pure state class that the notifier manages.
//  2. The clearError transition logic (replicated as a pure function).
//  3. The error-state construction triggered by sign-in exceptions.
//  4. AuthErrorMessages – the utility that converts exceptions into the
//     user-visible strings that the notifier stores in state.errorMessage.
// ---------------------------------------------------------------------------

/// Replicates the AuthNotifier.clearError behaviour without Riverpod.
AppAuthState applyClearError(AppAuthState current) {
  if (current.status == AuthStatus.error) {
    return AppAuthState.unauthenticated();
  }
  return current;
}

/// Replicates the AuthNotifier.signInWithEmail error path without Supabase.
AppAuthState applySignInError(dynamic exception) {
  return AppAuthState.error(AuthErrorMessages.fromException(exception));
}

void main() {
  group('AppAuthState – factory constructors', () {
    test('initial() has status=initial, no user, no errorMessage', () {
      final s = AppAuthState.initial();
      expect(s.status, equals(AuthStatus.initial));
      expect(s.user, isNull);
      expect(s.errorMessage, isNull);
    });

    test('unauthenticated() has status=unauthenticated, no user', () {
      final s = AppAuthState.unauthenticated();
      expect(s.status, equals(AuthStatus.unauthenticated));
      expect(s.user, isNull);
      expect(s.errorMessage, isNull);
    });

    test('loading() has status=loading', () {
      final s = AppAuthState.loading();
      expect(s.status, equals(AuthStatus.loading));
      expect(s.user, isNull);
      expect(s.errorMessage, isNull);
    });

    test('error() has status=error with the supplied message', () {
      const msg = 'Something went wrong';
      final s = AppAuthState.error(msg);
      expect(s.status, equals(AuthStatus.error));
      expect(s.errorMessage, equals(msg));
      expect(s.user, isNull);
    });
  });

  group('AppAuthState.copyWith', () {
    test('copyWith status only', () {
      final original = AppAuthState.error('oops');
      final updated = original.copyWith(status: AuthStatus.loading);
      expect(updated.status, equals(AuthStatus.loading));
      // errorMessage should be reset to null by copyWith when not provided
      expect(updated.errorMessage, isNull);
    });

    test('copyWith preserves unspecified fields', () {
      final original = AppAuthState.loading();
      final copy = original.copyWith();
      expect(copy.status, equals(original.status));
      expect(copy.user, isNull);
      expect(copy.errorMessage, isNull);
    });
  });

  // -------------------------------------------------------------------------
  // Sign-in error path (AuthNotifier.signInWithEmail catch block)
  // -------------------------------------------------------------------------
  group('Sign-in exception → error state', () {
    test('generic exception produces error status', () {
      final errorState =
          applySignInError(Exception('Something went wrong'));
      expect(errorState.status, equals(AuthStatus.error));
      expect(errorState.errorMessage, isNotNull);
      expect(errorState.errorMessage, isA<String>());
    });

    test('exception with "network" in message produces connectivity message', () {
      final errorState =
          applySignInError(Exception('network connection failed'));
      expect(errorState.status, equals(AuthStatus.error));
      expect(
        errorState.errorMessage,
        contains('internet connection'),
      );
    });

    test('exception with "invalid login credentials" produces credentials message', () {
      final errorState =
          applySignInError(Exception('invalid login credentials'));
      expect(errorState.status, equals(AuthStatus.error));
      expect(
        errorState.errorMessage,
        contains('Invalid email or password'),
      );
    });

    test('exception with "email not confirmed" produces confirmation message', () {
      final errorState =
          applySignInError(Exception('email not confirmed'));
      expect(errorState.status, equals(AuthStatus.error));
      expect(
        errorState.errorMessage,
        contains('confirmation link'),
      );
    });

    test('exception with "too many requests" produces rate-limit message', () {
      final errorState =
          applySignInError(Exception('too many requests'));
      expect(errorState.status, equals(AuthStatus.error));
      expect(
        errorState.errorMessage,
        contains('Too many attempts'),
      );
    });

    test('unknown exception produces fallback message', () {
      final errorState =
          applySignInError(Exception('some completely unknown error xyz'));
      expect(errorState.status, equals(AuthStatus.error));
      expect(errorState.errorMessage, equals('Something went wrong. Please try again.'));
    });

    test('error state stores non-empty error message', () {
      final errorState = applySignInError(Exception('anything'));
      expect(errorState.errorMessage, isNotEmpty);
    });

    test('error state has null user', () {
      final errorState = applySignInError(Exception('bad credentials'));
      expect(errorState.user, isNull);
    });
  });

  // -------------------------------------------------------------------------
  // clearError transition (AuthNotifier.clearError)
  // -------------------------------------------------------------------------
  group('clearError state transition', () {
    test('error state transitions to unauthenticated', () {
      final errorState = AppAuthState.error('Something went wrong');
      final result = applyClearError(errorState);

      expect(result.status, equals(AuthStatus.unauthenticated));
      expect(result.errorMessage, isNull);
      expect(result.user, isNull);
    });

    test('clearError on non-error state is a no-op', () {
      final loadingState = AppAuthState.loading();
      final result = applyClearError(loadingState);

      expect(result.status, equals(AuthStatus.loading));
    });

    test('clearError on unauthenticated state is a no-op', () {
      final unauthState = AppAuthState.unauthenticated();
      final result = applyClearError(unauthState);

      expect(result.status, equals(AuthStatus.unauthenticated));
    });

    test('clearError on initial state is a no-op', () {
      final initialState = AppAuthState.initial();
      final result = applyClearError(initialState);

      expect(result.status, equals(AuthStatus.initial));
    });

    test('clearError removes the error message', () {
      final errorState = AppAuthState.error('Invalid credentials');
      final cleared = applyClearError(errorState);

      expect(cleared.errorMessage, isNull);
    });

    test('sign-in error followed by clearError ends in unauthenticated', () {
      // Simulate the full notifier lifecycle for sign-in failure + clear
      final afterError = applySignInError(Exception('wrong password'));
      expect(afterError.status, equals(AuthStatus.error));

      final afterClear = applyClearError(afterError);
      expect(afterClear.status, equals(AuthStatus.unauthenticated));
      expect(afterClear.errorMessage, isNull);
    });
  });

  // -------------------------------------------------------------------------
  // AuthErrorMessages utility (used by the notifier for all error messages)
  // -------------------------------------------------------------------------
  group('AuthErrorMessages.fromException', () {
    test('returns non-empty string for any exception', () {
      final msg = AuthErrorMessages.fromException(Exception('anything'));
      expect(msg, isNotEmpty);
    });

    test('"user already registered" maps to sign-in suggestion', () {
      final msg = AuthErrorMessages.fromException(
          Exception('user already registered'));
      expect(msg, contains('already exists'));
    });

    test('"user not found" maps to sign-up suggestion', () {
      final msg = AuthErrorMessages.fromException(
          Exception('user not found'));
      expect(msg, contains('sign up'));
    });

    test('"expired" message maps to session-expired text', () {
      final msg = AuthErrorMessages.fromException(
          Exception('session expired'));
      expect(msg, contains('expired'));
    });

    test('"invalid email" message maps to valid-email prompt', () {
      final msg = AuthErrorMessages.fromException(
          Exception('invalid email format'));
      expect(msg, contains('valid email'));
    });
  });

  group('AuthErrorMessages.isEmailNotConfirmed', () {
    test('returns true when message contains "email not confirmed"', () {
      expect(
        AuthErrorMessages.isEmailNotConfirmed(
            Exception('email not confirmed')),
        isTrue,
      );
    });

    test('returns false for unrelated error', () {
      expect(
        AuthErrorMessages.isEmailNotConfirmed(Exception('network error')),
        isFalse,
      );
    });
  });

  group('AuthErrorMessages.isInvalidCredentials', () {
    test('returns true for "invalid login credentials"', () {
      expect(
        AuthErrorMessages.isInvalidCredentials(
            Exception('invalid login credentials')),
        isTrue,
      );
    });

    test('returns true for "wrong password"', () {
      expect(
        AuthErrorMessages.isInvalidCredentials(Exception('wrong password')),
        isTrue,
      );
    });

    test('returns false for unrelated error', () {
      expect(
        AuthErrorMessages.isInvalidCredentials(Exception('network error')),
        isFalse,
      );
    });
  });

  group('AuthErrorMessages.isRateLimited', () {
    test('returns true for "too many requests"', () {
      expect(
        AuthErrorMessages.isRateLimited(Exception('too many requests')),
        isTrue,
      );
    });

    test('returns true for "rate limit" message', () {
      expect(
        AuthErrorMessages.isRateLimited(Exception('rate limit exceeded')),
        isTrue,
      );
    });

    test('returns false for unrelated error', () {
      expect(
        AuthErrorMessages.isRateLimited(Exception('invalid credentials')),
        isFalse,
      );
    });
  });
}
