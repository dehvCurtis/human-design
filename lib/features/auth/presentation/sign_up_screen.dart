import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../../shared/widgets/widgets.dart';
import '../data/auth_repository.dart';
import '../domain/auth_errors.dart';
import '../domain/auth_providers.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  bool _isAppleLoading = false;
  bool _isGoogleLoading = false;
  bool _isMicrosoftLoading = false;
  bool _isFacebookLoading = false;
  String? _errorMessage;

  bool get _anyLoading =>
      _isAppleLoading ||
      _isGoogleLoading ||
      _isMicrosoftLoading ||
      _isFacebookLoading;

  Future<void> _signUpWithApple() async {
    setState(() {
      _isAppleLoading = true;
      _errorMessage = null;
    });

    try {
      await ref.read(authNotifierProvider.notifier).signInWithApple();
      final authState = ref.read(authNotifierProvider);
      if (authState.status == AuthStatus.error && mounted) {
        setState(() {
          _errorMessage = authState.errorMessage;
        });
      }
    } catch (e) {
      if (mounted && !AuthErrorMessages.isAppleSignInCancelled(e)) {
        setState(() {
          _errorMessage = AuthErrorMessages.fromException(e);
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isAppleLoading = false;
        });
      }
    }
  }

  Future<void> _signUpWithGoogle() async {
    setState(() {
      _isGoogleLoading = true;
      _errorMessage = null;
    });

    try {
      await ref.read(authNotifierProvider.notifier).signInWithGoogle();
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = AuthErrorMessages.fromException(e);
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isGoogleLoading = false;
        });
      }
    }
  }

  Future<void> _signUpWithMicrosoft() async {
    setState(() {
      _isMicrosoftLoading = true;
      _errorMessage = null;
    });

    try {
      await ref.read(authNotifierProvider.notifier).signInWithMicrosoft();
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = AuthErrorMessages.fromException(e);
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isMicrosoftLoading = false;
        });
      }
    }
  }

  Future<void> _signUpWithFacebook() async {
    setState(() {
      _isFacebookLoading = true;
      _errorMessage = null;
    });

    try {
      await ref.read(authNotifierProvider.notifier).signInWithFacebook();
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = AuthErrorMessages.fromException(e);
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isFacebookLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: isDark
                ? AppColors.textPrimaryDark
                : AppColors.textPrimaryLight,
          ),
          onPressed: () => context.canPop()
              ? context.pop()
              : context.go(AppRoutes.onboarding),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              // Header
              Text(
                l10n.auth_createAccount,
                style: theme.textTheme.displaySmall,
              ),
              const SizedBox(height: 8),
              Text(
                l10n.auth_signUpSubtitle,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: isDark
                      ? AppColors.textSecondaryDark
                      : AppColors.textSecondaryLight,
                ),
              ),
              const SizedBox(height: 40),

              // Error message
              if (_errorMessage != null) ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.error.withAlpha(25),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.error.withAlpha(128)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline,
                          color: AppColors.error, size: 20),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _errorMessage!,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: AppColors.error,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ],

              // OAuth buttons
              AppleSignInButton(
                onPressed: _anyLoading ? null : _signUpWithApple,
                isLoading: _isAppleLoading,
                label: l10n.auth_signUpWithApple,
              ),
              const SizedBox(height: 12),
              GoogleSignInButton(
                onPressed: _anyLoading ? null : _signUpWithGoogle,
                isLoading: _isGoogleLoading,
                label: l10n.auth_signUpWithGoogle,
              ),
              const SizedBox(height: 12),
              MicrosoftSignInButton(
                onPressed: _anyLoading ? null : _signUpWithMicrosoft,
                isLoading: _isMicrosoftLoading,
                label: l10n.auth_signUpWithMicrosoft,
              ),
              const SizedBox(height: 12),
              FacebookSignInButton(
                onPressed: _anyLoading ? null : _signUpWithFacebook,
                isLoading: _isFacebookLoading,
                label: l10n.auth_signUpWithFacebook,
              ),
              const SizedBox(height: 32),

              // Terms notice
              Text(
                l10n.auth_oauthTermsNotice,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: isDark
                      ? AppColors.textSecondaryDark
                      : AppColors.textSecondaryLight,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              // Sign in link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    l10n.auth_hasAccount,
                    style: theme.textTheme.bodyMedium,
                  ),
                  TextButton(
                    onPressed: _anyLoading
                        ? null
                        : () => context.go(AppRoutes.signIn),
                    child: Text(l10n.auth_signIn),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
