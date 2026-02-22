import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../../shared/widgets/widgets.dart';
import '../domain/auth_errors.dart';
import '../domain/auth_providers.dart';

class SignInScreen extends ConsumerStatefulWidget {
  const SignInScreen({super.key});

  @override
  ConsumerState<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<SignInScreen> {
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

  Future<void> _signInWithApple() async {
    setState(() {
      _isAppleLoading = true;
      _errorMessage = null;
    });

    try {
      await ref.read(authNotifierProvider.notifier).signInWithApple();
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

  Future<void> _signInWithGoogle() async {
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

  Future<void> _signInWithMicrosoft() async {
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

  Future<void> _signInWithFacebook() async {
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
                l10n.auth_welcomeBack,
                style: theme.textTheme.displaySmall,
              ),
              const SizedBox(height: 8),
              Text(
                l10n.auth_signInSubtitle,
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
                onPressed: _anyLoading ? null : _signInWithApple,
                isLoading: _isAppleLoading,
              ),
              const SizedBox(height: 12),
              GoogleSignInButton(
                onPressed: _anyLoading ? null : _signInWithGoogle,
                isLoading: _isGoogleLoading,
              ),
              const SizedBox(height: 12),
              MicrosoftSignInButton(
                onPressed: _anyLoading ? null : _signInWithMicrosoft,
                isLoading: _isMicrosoftLoading,
                label: l10n.auth_signInWithMicrosoft,
              ),
              const SizedBox(height: 12),
              FacebookSignInButton(
                onPressed: _anyLoading ? null : _signInWithFacebook,
                isLoading: _isFacebookLoading,
                label: l10n.auth_signInWithFacebook,
              ),
              const SizedBox(height: 32),

              // Sign up link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    l10n.auth_noAccount,
                    style: theme.textTheme.bodyMedium,
                  ),
                  TextButton(
                    onPressed: _anyLoading
                        ? null
                        : () => context.go(AppRoutes.signUp),
                    child: Text(l10n.auth_signUp),
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
