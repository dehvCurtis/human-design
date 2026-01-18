import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

/// Primary action button with consistent styling
class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.onPressed,
    required this.label,
    this.icon,
    this.isLoading = false,
    this.enabled = true,
    this.expanded = true,
    this.size = ButtonSize.large,
    this.variant = ButtonVariant.filled,
  });

  final VoidCallback? onPressed;
  final String label;
  final IconData? icon;
  final bool isLoading;
  final bool enabled;
  final bool expanded;
  final ButtonSize size;
  final ButtonVariant variant;

  @override
  Widget build(BuildContext context) {
    final buttonStyle = _getButtonStyle(context);
    final effectiveOnPressed = (enabled && !isLoading) ? onPressed : null;

    Widget child = Row(
      mainAxisSize: expanded ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (isLoading) ...[
          SizedBox(
            width: _getLoadingSize(),
            height: _getLoadingSize(),
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                variant == ButtonVariant.filled
                    ? Colors.white
                    : AppColors.primary,
              ),
            ),
          ),
          const SizedBox(width: 12),
        ] else if (icon != null) ...[
          Icon(icon, size: _getIconSize()),
          const SizedBox(width: 8),
        ],
        Text(label),
      ],
    );

    switch (variant) {
      case ButtonVariant.filled:
        return SizedBox(
          width: expanded ? double.infinity : null,
          height: _getHeight(),
          child: ElevatedButton(
            onPressed: effectiveOnPressed,
            style: buttonStyle,
            child: child,
          ),
        );
      case ButtonVariant.outlined:
        return SizedBox(
          width: expanded ? double.infinity : null,
          height: _getHeight(),
          child: OutlinedButton(
            onPressed: effectiveOnPressed,
            style: buttonStyle,
            child: child,
          ),
        );
      case ButtonVariant.text:
        return SizedBox(
          height: _getHeight(),
          child: TextButton(
            onPressed: effectiveOnPressed,
            style: buttonStyle,
            child: child,
          ),
        );
    }
  }

  double _getHeight() {
    switch (size) {
      case ButtonSize.small:
        return 36;
      case ButtonSize.medium:
        return 44;
      case ButtonSize.large:
        return 52;
    }
  }

  double _getIconSize() {
    switch (size) {
      case ButtonSize.small:
        return 16;
      case ButtonSize.medium:
        return 18;
      case ButtonSize.large:
        return 20;
    }
  }

  double _getLoadingSize() {
    switch (size) {
      case ButtonSize.small:
        return 14;
      case ButtonSize.medium:
        return 16;
      case ButtonSize.large:
        return 18;
    }
  }

  ButtonStyle? _getButtonStyle(BuildContext context) {
    final borderRadius = BorderRadius.circular(12);

    switch (variant) {
      case ButtonVariant.filled:
        return ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          disabledBackgroundColor: AppColors.primary.withAlpha(128),
          disabledForegroundColor: Colors.white.withAlpha(179),
          shape: RoundedRectangleBorder(borderRadius: borderRadius),
          textStyle: _getTextStyle(),
        );
      case ButtonVariant.outlined:
        return OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.primary),
          shape: RoundedRectangleBorder(borderRadius: borderRadius),
          textStyle: _getTextStyle(),
        );
      case ButtonVariant.text:
        return TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          textStyle: _getTextStyle(),
        );
    }
  }

  TextStyle _getTextStyle() {
    switch (size) {
      case ButtonSize.small:
        return const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        );
      case ButtonSize.medium:
        return const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
        );
      case ButtonSize.large:
        return const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        );
    }
  }
}

/// Button size variants
enum ButtonSize { small, medium, large }

/// Button style variants
enum ButtonVariant { filled, outlined, text }

/// Secondary button (outlined style)
class SecondaryButton extends StatelessWidget {
  const SecondaryButton({
    super.key,
    required this.onPressed,
    required this.label,
    this.icon,
    this.isLoading = false,
    this.enabled = true,
    this.expanded = true,
    this.size = ButtonSize.large,
  });

  final VoidCallback? onPressed;
  final String label;
  final IconData? icon;
  final bool isLoading;
  final bool enabled;
  final bool expanded;
  final ButtonSize size;

  @override
  Widget build(BuildContext context) {
    return PrimaryButton(
      onPressed: onPressed,
      label: label,
      icon: icon,
      isLoading: isLoading,
      enabled: enabled,
      expanded: expanded,
      size: size,
      variant: ButtonVariant.outlined,
    );
  }
}

/// Text-only button
class TertiaryButton extends StatelessWidget {
  const TertiaryButton({
    super.key,
    required this.onPressed,
    required this.label,
    this.icon,
    this.isLoading = false,
    this.enabled = true,
    this.size = ButtonSize.medium,
  });

  final VoidCallback? onPressed;
  final String label;
  final IconData? icon;
  final bool isLoading;
  final bool enabled;
  final ButtonSize size;

  @override
  Widget build(BuildContext context) {
    return PrimaryButton(
      onPressed: onPressed,
      label: label,
      icon: icon,
      isLoading: isLoading,
      enabled: enabled,
      expanded: false,
      size: size,
      variant: ButtonVariant.text,
    );
  }
}
