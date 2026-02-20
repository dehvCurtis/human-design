import 'package:supabase_flutter/supabase_flutter.dart';

/// User-friendly error messages for authentication errors
class AuthErrorMessages {
  AuthErrorMessages._();

  /// Convert a Supabase auth exception to a user-friendly message
  static String fromException(dynamic exception) {
    if (exception is AuthException) {
      return fromAuthException(exception);
    }

    final message = exception.toString().toLowerCase();

    // Check for common error patterns
    if (message.contains('email not confirmed')) {
      return 'Please check your email and click the confirmation link before signing in.';
    }
    if (message.contains('invalid login credentials') ||
        message.contains('invalid credentials')) {
      return 'Invalid email or password. Please check your credentials and try again.';
    }
    if (message.contains('user not found')) {
      return 'No account found with this email. Please sign up first.';
    }
    if (message.contains('email already registered') ||
        message.contains('user already registered')) {
      return 'An account with this email already exists. Please sign in instead.';
    }
    if (message.contains('password')) {
      if (message.contains('weak') || message.contains('short')) {
        return 'Password is too weak. Please use at least 8 characters with a mix of letters and numbers.';
      }
      return 'Invalid password. Please check and try again.';
    }
    if (message.contains('network') || message.contains('connection')) {
      return 'Unable to connect. Please check your internet connection and try again.';
    }
    if (message.contains('too many requests') || message.contains('rate limit')) {
      return 'Too many attempts. Please wait a few minutes before trying again.';
    }
    if (message.contains('expired')) {
      return 'Your session has expired. Please sign in again.';
    }
    if (message.contains('invalid email')) {
      return 'Please enter a valid email address.';
    }

    // Default fallback - don't expose technical details
    return 'Something went wrong. Please try again.';
  }

  /// Convert AuthException to user-friendly message
  static String fromAuthException(AuthException exception) {
    final message = exception.message.toLowerCase();
    final code = exception.statusCode;

    // Handle by status code first
    switch (code) {
      case '400':
        if (message.contains('email not confirmed')) {
          return 'Please check your email and click the confirmation link before signing in.';
        }
        if (message.contains('invalid')) {
          return 'Invalid email or password. Please check your credentials.';
        }
        return 'Invalid request. Please check your information and try again.';
      case '401':
        return 'Invalid email or password. Please try again.';
      case '403':
        return 'Access denied. Please contact support if this continues.';
      case '404':
        return 'No account found with this email. Please sign up first.';
      case '422':
        if (message.contains('email')) {
          return 'Please enter a valid email address.';
        }
        if (message.contains('password')) {
          return 'Password must be at least 6 characters.';
        }
        return 'Please check your information and try again.';
      case '429':
        return 'Too many attempts. Please wait a few minutes before trying again.';
      case '500':
      case '502':
      case '503':
        return 'Our servers are temporarily unavailable. Please try again later.';
    }

    // Handle by message content
    if (message.contains('email not confirmed')) {
      return 'Please check your email and click the confirmation link before signing in.';
    }
    if (message.contains('invalid login credentials')) {
      return 'Invalid email or password. Please check your credentials and try again.';
    }
    if (message.contains('user already registered')) {
      return 'An account with this email already exists. Please sign in instead.';
    }

    return 'Something went wrong. Please try again.';
  }

  /// Check if the error is specifically about email not being confirmed
  static bool isEmailNotConfirmed(dynamic exception) {
    final message = exception.toString().toLowerCase();
    return message.contains('email not confirmed');
  }

  /// Check if the error is about invalid credentials
  static bool isInvalidCredentials(dynamic exception) {
    final message = exception.toString().toLowerCase();
    return message.contains('invalid login credentials') ||
           message.contains('invalid credentials') ||
           message.contains('wrong password');
  }

  /// Check if the error is about user not found
  static bool isUserNotFound(dynamic exception) {
    final message = exception.toString().toLowerCase();
    return message.contains('user not found') ||
           message.contains('no user');
  }

  /// Check if the error is an Apple Sign In cancellation (user dismissed the dialog)
  static bool isAppleSignInCancelled(dynamic exception) {
    final message = exception.toString().toLowerCase();
    return message.contains('authorizationerrorcode.canceled') ||
        message.contains('com.apple.authenticationservices.authorizationerror error 1001') ||
        message.contains('asauthorizationerror') && message.contains('cancel');
  }

  /// Check if the error is about rate limiting
  static bool isRateLimited(dynamic exception) {
    final message = exception.toString().toLowerCase();
    return message.contains('too many requests') ||
           message.contains('rate limit');
  }
}
