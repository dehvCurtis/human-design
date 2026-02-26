import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../l10n/generated/app_localizations.dart';

/// A reusable bottom sheet for showing details
class DetailBottomSheet extends StatelessWidget {
  const DetailBottomSheet({
    super.key,
    required this.title,
    required this.child,
    this.subtitle,
    this.leading,
    this.trailing,
    this.actions,
    this.maxHeight,
    this.showDragHandle = true,
    this.padding = const EdgeInsets.all(24),
  });

  final String title;
  final String? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final Widget child;
  final List<Widget>? actions;
  final double? maxHeight;
  final bool showDragHandle;
  final EdgeInsets padding;

  /// Show the bottom sheet
  static Future<T?> show<T>({
    required BuildContext context,
    required String title,
    required Widget child,
    String? subtitle,
    Widget? leading,
    Widget? trailing,
    List<Widget>? actions,
    double? maxHeight,
    bool showDragHandle = true,
    bool isScrollControlled = true,
    bool isDismissible = true,
    bool enableDrag = true,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: isScrollControlled,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      backgroundColor: Colors.transparent,
      builder: (context) => DetailBottomSheet(
        title: title,
        subtitle: subtitle,
        leading: leading,
        trailing: trailing,
        actions: actions,
        maxHeight: maxHeight,
        showDragHandle: showDragHandle,
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final mediaQuery = MediaQuery.of(context);
    final effectiveMaxHeight =
        maxHeight ?? (mediaQuery.size.height * 0.85);

    return Container(
      constraints: BoxConstraints(maxHeight: effectiveMaxHeight),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showDragHandle)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.dividerDark
                      : AppColors.dividerLight,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
            child: Row(
              children: [
                if (leading != null) ...[
                  leading!,
                  const SizedBox(width: 16),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: theme.textTheme.headlineSmall,
                      ),
                      if (subtitle != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          subtitle!,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: isDark
                                ? AppColors.textSecondaryDark
                                : AppColors.textSecondaryLight,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                ?trailing,
              ],
            ),
          ),
          const Divider(),
          Flexible(
            child: SingleChildScrollView(
              padding: padding,
              child: child,
            ),
          ),
          if (actions != null && actions!.isNotEmpty) ...[
            const Divider(height: 1),
            Padding(
              padding: EdgeInsets.fromLTRB(
                24,
                16,
                24,
                16 + mediaQuery.viewPadding.bottom,
              ),
              child: Row(
                children: [
                  for (int i = 0; i < actions!.length; i++) ...[
                    if (i > 0) const SizedBox(width: 12),
                    Expanded(child: actions![i]),
                  ],
                ],
              ),
            ),
          ] else
            SizedBox(height: mediaQuery.viewPadding.bottom),
        ],
      ),
    );
  }
}

/// Confirmation dialog as a bottom sheet
class ConfirmationBottomSheet extends StatelessWidget {
  const ConfirmationBottomSheet({
    super.key,
    required this.title,
    required this.message,
    this.confirmLabel,
    this.cancelLabel,
    this.isDestructive = false,
    this.icon,
  });

  final String title;
  final String message;
  final String? confirmLabel;
  final String? cancelLabel;
  final bool isDestructive;
  final IconData? icon;

  /// Show the confirmation bottom sheet
  static Future<bool?> show({
    required BuildContext context,
    required String title,
    required String message,
    String? confirmLabel,
    String? cancelLabel,
    bool isDestructive = false,
    IconData? icon,
  }) {
    return showModalBottomSheet<bool>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => ConfirmationBottomSheet(
        title: title,
        message: message,
        confirmLabel: confirmLabel,
        cancelLabel: cancelLabel,
        isDestructive: isDestructive,
        icon: icon,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final mediaQuery = MediaQuery.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.fromLTRB(
        24,
        24,
        24,
        24 + mediaQuery.viewPadding.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: (isDestructive ? AppColors.error : AppColors.primary)
                    .withAlpha(25),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: isDestructive ? AppColors.error : AppColors.primary,
                size: 28,
              ),
            ),
            const SizedBox(height: 16),
          ],
          Text(
            title,
            style: theme.textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: isDark
                  ? AppColors.textSecondaryDark
                  : AppColors.textSecondaryLight,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(cancelLabel ?? l10n.common_cancel),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        isDestructive ? AppColors.error : AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(confirmLabel ?? l10n.common_confirm),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Simple info bottom sheet
class InfoBottomSheet extends StatelessWidget {
  const InfoBottomSheet({
    super.key,
    required this.title,
    required this.content,
    this.icon,
    this.buttonLabel,
  });

  final String title;
  final String content;
  final IconData? icon;
  final String? buttonLabel;

  static Future<void> show({
    required BuildContext context,
    required String title,
    required String content,
    IconData? icon,
    String? buttonLabel,
  }) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => InfoBottomSheet(
        title: title,
        content: content,
        icon: icon,
        buttonLabel: buttonLabel,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final mediaQuery = MediaQuery.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.fromLTRB(
        24,
        24,
        24,
        24 + mediaQuery.viewPadding.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: 48,
              color: AppColors.primary,
            ),
            const SizedBox(height: 16),
          ],
          Text(
            title,
            style: theme.textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: isDark
                  ? AppColors.textSecondaryDark
                  : AppColors.textSecondaryLight,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text(buttonLabel ?? l10n.common_gotIt),
            ),
          ),
        ],
      ),
    );
  }
}
