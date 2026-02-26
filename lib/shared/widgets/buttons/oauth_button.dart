import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../l10n/generated/app_localizations.dart';

/// OAuth provider types
enum OAuthProvider { apple, google, microsoft, facebook }

/// OAuth sign-in button with provider branding
class OAuthButton extends StatelessWidget {
  const OAuthButton({
    super.key,
    required this.provider,
    required this.onPressed,
    this.isLoading = false,
    this.enabled = true,
    this.label,
  });

  final OAuthProvider provider;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool enabled;
  final String? label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final effectiveOnPressed = (enabled && !isLoading) ? onPressed : null;

    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: effectiveOnPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: _getBackgroundColor(isDark),
          foregroundColor: _getForegroundColor(isDark),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: isDark ? AppColors.dividerDark : AppColors.dividerLight,
              width: 1,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isLoading)
              SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    _getForegroundColor(isDark),
                  ),
                ),
              )
            else
              _buildProviderIcon(isDark),
            const SizedBox(width: 12),
            Text(
              label ?? _getDefaultLabel(AppLocalizations.of(context)!),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProviderIcon(bool isDark) {
    switch (provider) {
      case OAuthProvider.apple:
        return Icon(
          Icons.apple,
          size: 24,
          color: _getForegroundColor(isDark),
        );
      case OAuthProvider.google:
        return _GoogleLogo(size: 20);
      case OAuthProvider.microsoft:
        return _MicrosoftLogo(size: 20);
      case OAuthProvider.facebook:
        return Icon(
          Icons.facebook,
          size: 24,
          color: _getForegroundColor(isDark),
        );
    }
  }

  Color _getBackgroundColor(bool isDark) {
    switch (provider) {
      case OAuthProvider.apple:
        return isDark ? Colors.white : Colors.black;
      case OAuthProvider.google:
      case OAuthProvider.microsoft:
        return isDark ? AppColors.surfaceDark : AppColors.surfaceLight;
      case OAuthProvider.facebook:
        return const Color(0xFF1877F2);
    }
  }

  Color _getForegroundColor(bool isDark) {
    switch (provider) {
      case OAuthProvider.apple:
        return isDark ? Colors.black : Colors.white;
      case OAuthProvider.google:
      case OAuthProvider.microsoft:
        return isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
      case OAuthProvider.facebook:
        return Colors.white;
    }
  }

  String _getDefaultLabel(AppLocalizations l10n) {
    switch (provider) {
      case OAuthProvider.apple:
        return l10n.oauth_continueWithApple;
      case OAuthProvider.google:
        return l10n.oauth_continueWithGoogle;
      case OAuthProvider.microsoft:
        return l10n.oauth_continueWithMicrosoft;
      case OAuthProvider.facebook:
        return l10n.oauth_continueWithFacebook;
    }
  }
}

/// Apple Sign In button
class AppleSignInButton extends StatelessWidget {
  const AppleSignInButton({
    super.key,
    required this.onPressed,
    this.isLoading = false,
    this.enabled = true,
    this.label,
  });

  final VoidCallback? onPressed;
  final bool isLoading;
  final bool enabled;
  final String? label;

  @override
  Widget build(BuildContext context) {
    return OAuthButton(
      provider: OAuthProvider.apple,
      onPressed: onPressed,
      isLoading: isLoading,
      enabled: enabled,
      label: label ?? AppLocalizations.of(context)!.oauth_continueWithApple,
    );
  }
}

/// Google Sign In button
class GoogleSignInButton extends StatelessWidget {
  const GoogleSignInButton({
    super.key,
    required this.onPressed,
    this.isLoading = false,
    this.enabled = true,
    this.label,
  });

  final VoidCallback? onPressed;
  final bool isLoading;
  final bool enabled;
  final String? label;

  @override
  Widget build(BuildContext context) {
    return OAuthButton(
      provider: OAuthProvider.google,
      onPressed: onPressed,
      isLoading: isLoading,
      enabled: enabled,
      label: label ?? AppLocalizations.of(context)!.oauth_continueWithGoogle,
    );
  }
}

/// Custom Google logo widget (since Material Icons doesn't include it)
class _GoogleLogo extends StatelessWidget {
  const _GoogleLogo({this.size = 24});

  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _GoogleLogoPainter(),
      ),
    );
  }
}

class _GoogleLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Blue section
    paint.color = const Color(0xFF4285F4);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -0.5,
      1.9,
      true,
      paint,
    );

    // Green section
    paint.color = const Color(0xFF34A853);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      1.4,
      1.2,
      true,
      paint,
    );

    // Yellow section
    paint.color = const Color(0xFFFBBC05);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      2.6,
      0.9,
      true,
      paint,
    );

    // Red section
    paint.color = const Color(0xFFEA4335);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      3.5,
      0.9,
      true,
      paint,
    );

    // White center
    paint.color = Colors.white;
    canvas.drawCircle(center, radius * 0.55, paint);

    // Blue G shape
    paint.color = const Color(0xFF4285F4);
    final gPath = Path()
      ..moveTo(size.width * 0.5, size.height * 0.3)
      ..lineTo(size.width * 0.85, size.height * 0.3)
      ..lineTo(size.width * 0.85, size.height * 0.55)
      ..lineTo(size.width * 0.55, size.height * 0.55)
      ..lineTo(size.width * 0.55, size.height * 0.45)
      ..lineTo(size.width * 0.75, size.height * 0.45)
      ..lineTo(size.width * 0.75, size.height * 0.4)
      ..lineTo(size.width * 0.5, size.height * 0.4)
      ..close();
    canvas.drawPath(gPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Microsoft Sign In button
class MicrosoftSignInButton extends StatelessWidget {
  const MicrosoftSignInButton({
    super.key,
    required this.onPressed,
    this.isLoading = false,
    this.enabled = true,
    this.label,
  });

  final VoidCallback? onPressed;
  final bool isLoading;
  final bool enabled;
  final String? label;

  @override
  Widget build(BuildContext context) {
    return OAuthButton(
      provider: OAuthProvider.microsoft,
      onPressed: onPressed,
      isLoading: isLoading,
      enabled: enabled,
      label: label ?? AppLocalizations.of(context)!.oauth_continueWithMicrosoft,
    );
  }
}

/// Facebook Sign In button
class FacebookSignInButton extends StatelessWidget {
  const FacebookSignInButton({
    super.key,
    required this.onPressed,
    this.isLoading = false,
    this.enabled = true,
    this.label,
  });

  final VoidCallback? onPressed;
  final bool isLoading;
  final bool enabled;
  final String? label;

  @override
  Widget build(BuildContext context) {
    return OAuthButton(
      provider: OAuthProvider.facebook,
      onPressed: onPressed,
      isLoading: isLoading,
      enabled: enabled,
      label: label ?? AppLocalizations.of(context)!.oauth_continueWithFacebook,
    );
  }
}

/// Custom Microsoft logo widget
class _MicrosoftLogo extends StatelessWidget {
  const _MicrosoftLogo({this.size = 24});

  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _MicrosoftLogoPainter(),
      ),
    );
  }
}

class _MicrosoftLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    final gap = size.width * 0.08;
    final half = (size.width - gap) / 2;

    // Top-left (red)
    paint.color = const Color(0xFFF25022);
    canvas.drawRect(Rect.fromLTWH(0, 0, half, half), paint);

    // Top-right (green)
    paint.color = const Color(0xFF7FBA00);
    canvas.drawRect(Rect.fromLTWH(half + gap, 0, half, half), paint);

    // Bottom-left (blue)
    paint.color = const Color(0xFF00A4EF);
    canvas.drawRect(Rect.fromLTWH(0, half + gap, half, half), paint);

    // Bottom-right (yellow)
    paint.color = const Color(0xFFFFB900);
    canvas.drawRect(Rect.fromLTWH(half + gap, half + gap, half, half), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Divider with "or" text for separating OAuth buttons from email login
class OAuthDivider extends StatelessWidget {
  const OAuthDivider({
    super.key,
    this.text,
  });

  final String? text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final color =
        isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Row(
        children: [
          Expanded(
            child: Divider(
              color: isDark ? AppColors.dividerDark : AppColors.dividerLight,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              text ?? l10n.common_or,
              style: theme.textTheme.bodyMedium?.copyWith(color: color),
            ),
          ),
          Expanded(
            child: Divider(
              color: isDark ? AppColors.dividerDark : AppColors.dividerLight,
            ),
          ),
        ],
      ),
    );
  }
}
