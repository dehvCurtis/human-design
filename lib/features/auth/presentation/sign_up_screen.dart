import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../../shared/widgets/widgets.dart';
import '../data/auth_repository.dart';
import '../domain/auth_providers.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();

  bool _isLoading = false;
  bool _isGoogleLoading = false;
  bool _isAppleLoading = false;
  bool _acceptedTerms = false;
  String? _errorMessage;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _nameFocusNode.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  Future<void> _signUpWithEmail() async {
    if (!_formKey.currentState!.validate()) return;

    if (!_acceptedTerms) {
      setState(() {
        _errorMessage = AppLocalizations.of(context)!.auth_acceptTerms;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await ref.read(authNotifierProvider.notifier).signUpWithEmail(
            email: _emailController.text.trim(),
            password: _passwordController.text,
            name: _nameController.text.trim(),
          );

      final authState = ref.read(authNotifierProvider);
      if (authState.status == AuthStatus.error && mounted) {
        setState(() {
          _errorMessage = authState.errorMessage;
          _isLoading = false;
        });
      } else if (authState.status == AuthStatus.authenticated && mounted) {
        // Navigate to birth data entry
        context.go(AppRoutes.birthData);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString();
          _isLoading = false;
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
          _errorMessage = e.toString();
          _isGoogleLoading = false;
        });
      }
    }
  }

  Future<void> _signUpWithApple() async {
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final anyLoading = _isLoading || _isGoogleLoading || _isAppleLoading;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
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
                  onPressed: anyLoading ? null : _signUpWithApple,
                  isLoading: _isAppleLoading,
                  label: l10n.auth_signUpWithApple,
                ),
                const SizedBox(height: 12),
                GoogleSignInButton(
                  onPressed: anyLoading ? null : _signUpWithGoogle,
                  isLoading: _isGoogleLoading,
                  label: l10n.auth_signUpWithGoogle,
                ),

                const OAuthDivider(),

                // Name field
                AppTextField(
                  controller: _nameController,
                  focusNode: _nameFocusNode,
                  label: l10n.auth_name,
                  hint: l10n.auth_enterName,
                  prefixIcon: Icons.person_outline,
                  textInputAction: TextInputAction.next,
                  textCapitalization: TextCapitalization.words,
                  enabled: !anyLoading,
                  onSubmitted: (_) => _emailFocusNode.requestFocus(),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return l10n.auth_nameRequired;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

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
                  validateStrength: true,
                  onSubmitted: (_) => _signUpWithEmail(),
                ),
                const SizedBox(height: 16),

                // Terms checkbox
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 24,
                      height: 24,
                      child: Checkbox(
                        value: _acceptedTerms,
                        onChanged: anyLoading
                            ? null
                            : (value) {
                                setState(() {
                                  _acceptedTerms = value ?? false;
                                  if (_acceptedTerms) {
                                    _errorMessage = null;
                                  }
                                });
                              },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: GestureDetector(
                        onTap: anyLoading
                            ? null
                            : () {
                                setState(() {
                                  _acceptedTerms = !_acceptedTerms;
                                  if (_acceptedTerms) {
                                    _errorMessage = null;
                                  }
                                });
                              },
                        child: RichText(
                          text: TextSpan(
                            style: theme.textTheme.bodyMedium,
                            children: [
                              TextSpan(text: l10n.auth_iAgreeTo),
                              TextSpan(
                                text: l10n.auth_termsOfService,
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              TextSpan(text: l10n.auth_and),
                              TextSpan(
                                text: l10n.auth_privacyPolicy,
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Sign up button
                PrimaryButton(
                  onPressed: anyLoading ? null : _signUpWithEmail,
                  label: l10n.auth_createAccount,
                  isLoading: _isLoading,
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
                      onPressed:
                          anyLoading ? null : () => context.go(AppRoutes.signIn),
                      child: Text(l10n.auth_signIn),
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
