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

class SignInScreen extends ConsumerStatefulWidget {
  const SignInScreen({super.key});

  @override
  ConsumerState<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();

  bool _isLoading = false;
  bool _isGoogleLoading = false;
  bool _isAppleLoading = false;
  String? _errorMessage;
  bool _showResendConfirmation = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  Future<void> _signInWithEmail() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _showResendConfirmation = false;
    });

    try {
      await ref.read(authNotifierProvider.notifier).signInWithEmail(
            email: _emailController.text.trim(),
            password: _passwordController.text,
          );

      final authState = ref.read(authNotifierProvider);
      if (authState.status == AuthStatus.error && mounted) {
        setState(() {
          _errorMessage = authState.errorMessage;
          _showResendConfirmation = authState.errorMessage?.contains('confirmation') ?? false;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        final friendlyMessage = AuthErrorMessages.fromException(e);
        setState(() {
          _errorMessage = friendlyMessage;
          _showResendConfirmation = AuthErrorMessages.isEmailNotConfirmed(e);
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _resendConfirmationEmail() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) return;

    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final l10n = AppLocalizations.of(context)!;

    try {
      await ref.read(authNotifierProvider.notifier).resendConfirmationEmail(email);
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text(l10n.auth_confirmationSent),
          backgroundColor: AppColors.success,
        ),
      );
    } catch (e) {
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text(AuthErrorMessages.fromException(e)),
          backgroundColor: AppColors.error,
        ),
      );
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
          _errorMessage = e.toString();
          _isGoogleLoading = false;
        });
      }
    }
  }

  Future<void> _signInWithApple() async {
    setState(() {
      _isAppleLoading = true;
      _errorMessage = null;
    });

    try {
      await ref.read(authNotifierProvider.notifier).signInWithApple();
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString();
          _isAppleLoading = false;
        });
      }
    }
  }

  void _showForgotPasswordDialog() {
    final emailController = TextEditingController(text: _emailController.text);
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.auth_resetPasswordTitle),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(l10n.auth_resetPasswordPrompt),
            const SizedBox(height: 16),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: l10n.auth_email,
                hintText: l10n.auth_enterEmail,
              ),
              keyboardType: TextInputType.emailAddress,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(l10n.common_cancel),
          ),
          ElevatedButton(
            onPressed: () async {
              if (emailController.text.isNotEmpty) {
                final scaffoldMessenger = ScaffoldMessenger.of(context);
                await ref
                    .read(authNotifierProvider.notifier)
                    .sendPasswordReset(emailController.text.trim());
                if (dialogContext.mounted) {
                  Navigator.pop(dialogContext);
                  scaffoldMessenger.showSnackBar(
                    SnackBar(
                      content: Text(l10n.auth_resetEmailSent),
                    ),
                  );
                }
              }
            },
            child: Text(l10n.common_send),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final anyLoading = _isLoading || _isGoogleLoading || _isAppleLoading;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
          onPressed: () => context.canPop() ? context.pop() : context.go(AppRoutes.onboarding),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
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
                        if (_showResendConfirmation) ...[
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            child: TextButton.icon(
                              onPressed: _resendConfirmationEmail,
                              icon: const Icon(Icons.email_outlined, size: 18),
                              label: Text(l10n.auth_resendConfirmation),
                              style: TextButton.styleFrom(
                                foregroundColor: AppColors.primary,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                ],

                // OAuth buttons
                AppleSignInButton(
                  onPressed: anyLoading ? null : _signInWithApple,
                  isLoading: _isAppleLoading,
                ),
                const SizedBox(height: 12),
                GoogleSignInButton(
                  onPressed: anyLoading ? null : _signInWithGoogle,
                  isLoading: _isGoogleLoading,
                ),

                const OAuthDivider(),

                // Email field
                EmailTextField(
                  controller: _emailController,
                  focusNode: _emailFocusNode,
                  enabled: !anyLoading,
                  onSubmitted: (_) => _passwordFocusNode.requestFocus(),
                ),
                const SizedBox(height: 16),

                // Password field
                PasswordTextField(
                  controller: _passwordController,
                  focusNode: _passwordFocusNode,
                  enabled: !anyLoading,
                  validateStrength: false,
                  onSubmitted: (_) => _signInWithEmail(),
                ),
                const SizedBox(height: 8),

                // Forgot password
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: anyLoading ? null : _showForgotPasswordDialog,
                    child: Text(l10n.auth_forgotPassword),
                  ),
                ),
                const SizedBox(height: 24),

                // Sign in button
                PrimaryButton(
                  onPressed: anyLoading ? null : _signInWithEmail,
                  label: l10n.auth_signIn,
                  isLoading: _isLoading,
                ),
                const SizedBox(height: 24),

                // Sign up link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      l10n.auth_noAccount,
                      style: theme.textTheme.bodyMedium,
                    ),
                    TextButton(
                      onPressed:
                          anyLoading ? null : () => context.go(AppRoutes.signUp),
                      child: Text(l10n.auth_signUp),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
