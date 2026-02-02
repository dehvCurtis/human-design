import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Error handler utility to sanitize error messages
///
/// Prevents internal error details from being exposed to users
/// while still logging full details for debugging.
class ErrorHandler {
  ErrorHandler._();

  /// Get a user-friendly error message
  ///
  /// Logs the full error for debugging but returns a sanitized
  /// message suitable for display to users.
  static String getUserMessage(dynamic error, {String? context}) {
    // Log full error for debugging
    if (context != null) {
      debugPrint('Error in $context: $error');
    } else {
      debugPrint('Error: $error');
    }

    if (error is StackTrace) {
      debugPrint('Stack trace: $error');
    }

    // Handle known error types with appropriate messages
    if (error is AuthException) {
      return _getAuthErrorMessage(error);
    }

    if (error is PostgrestException) {
      return _getDatabaseErrorMessage(error);
    }

    if (error is StorageException) {
      return _getStorageErrorMessage(error);
    }

    if (error is StateError) {
      // StateError often contains auth-related messages we set
      final message = error.message;
      if (message.contains('authenticated') || message.contains('logged in')) {
        return 'Please sign in to continue.';
      }
      if (message.contains('authorized')) {
        return 'You do not have permission to perform this action.';
      }
    }

    if (error is ArgumentError) {
      // ArgumentError may contain validation messages
      return 'Invalid input. Please check your data and try again.';
    }

    if (error is FormatException) {
      return 'Invalid format. Please check your input.';
    }

    // Network-related errors
    final errorString = error.toString().toLowerCase();
    if (errorString.contains('socketexception') ||
        errorString.contains('connection') ||
        errorString.contains('network')) {
      return 'Network error. Please check your connection and try again.';
    }

    if (errorString.contains('timeout')) {
      return 'Request timed out. Please try again.';
    }

    // Default generic message
    return 'Something went wrong. Please try again.';
  }

  static String _getAuthErrorMessage(AuthException error) {
    final message = error.message.toLowerCase();

    if (message.contains('invalid login credentials') ||
        message.contains('invalid password') ||
        message.contains('invalid email')) {
      return 'Invalid email or password.';
    }

    if (message.contains('email not confirmed')) {
      return 'Please verify your email address before signing in.';
    }

    if (message.contains('user already registered') ||
        message.contains('already exists')) {
      return 'An account with this email already exists.';
    }

    if (message.contains('rate limit') || message.contains('too many')) {
      return 'Too many attempts. Please wait a moment and try again.';
    }

    if (message.contains('expired') || message.contains('invalid token')) {
      return 'Your session has expired. Please sign in again.';
    }

    return 'Authentication error. Please try again.';
  }

  static String _getDatabaseErrorMessage(PostgrestException error) {
    final message = error.message.toLowerCase();

    if (message.contains('duplicate') || message.contains('unique')) {
      return 'This item already exists.';
    }

    if (message.contains('foreign key') || message.contains('reference')) {
      return 'This item is linked to other data and cannot be modified.';
    }

    if (message.contains('permission') || message.contains('policy')) {
      return 'You do not have permission to perform this action.';
    }

    return 'Unable to complete the operation. Please try again.';
  }

  static String _getStorageErrorMessage(StorageException error) {
    final message = error.message.toLowerCase();

    if (message.contains('size') || message.contains('large')) {
      return 'File is too large. Please choose a smaller file.';
    }

    if (message.contains('type') || message.contains('format')) {
      return 'File type not supported.';
    }

    if (message.contains('permission') || message.contains('access')) {
      return 'Unable to access file storage.';
    }

    return 'Unable to upload file. Please try again.';
  }

  /// Log an error without returning a message (for silent failures)
  static void logError(dynamic error, {String? context, StackTrace? stackTrace}) {
    if (context != null) {
      debugPrint('Error in $context: $error');
    } else {
      debugPrint('Error: $error');
    }

    if (stackTrace != null) {
      debugPrint('Stack trace: $stackTrace');
    }
  }
}
