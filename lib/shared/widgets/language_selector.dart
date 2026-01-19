import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/settings/domain/settings_providers.dart';
import '../../features/settings/domain/settings_state.dart';

/// A compact language selector showing flag emojis
/// Tapping shows a popup menu to change language
class LanguageSelector extends ConsumerWidget {
  const LanguageSelector({super.key, this.compact = true});

  /// If true, shows only the flag. If false, shows flag and language name
  final bool compact;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.watch(settingsProvider.select((s) => s.locale));

    return PopupMenuButton<AppLocale>(
      initialValue: currentLocale,
      onSelected: (locale) {
        ref.read(settingsProvider.notifier).setLocale(locale);
      },
      tooltip: 'Change Language',
      itemBuilder: (context) => AppLocale.values.map((locale) {
        return PopupMenuItem<AppLocale>(
          value: locale,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(locale.flag, style: const TextStyle(fontSize: 20)),
              const SizedBox(width: 12),
              Text(locale.displayName),
              if (locale == currentLocale) ...[
                const SizedBox(width: 8),
                const Icon(Icons.check, size: 18, color: Colors.green),
              ],
            ],
          ),
        );
      }).toList(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(currentLocale.flag, style: const TextStyle(fontSize: 22)),
            if (!compact) ...[
              const SizedBox(width: 4),
              Text(currentLocale.displayName),
            ],
            const Icon(Icons.arrow_drop_down, size: 18),
          ],
        ),
      ),
    );
  }
}

/// A row of flag buttons for quick language selection
/// Shows all available languages as tappable flag emojis
class LanguageFlagRow extends ConsumerWidget {
  const LanguageFlagRow({super.key, this.showLabels = false});

  final bool showLabels;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.watch(settingsProvider.select((s) => s.locale));

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: AppLocale.values.map((locale) {
        final isSelected = locale == currentLocale;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: InkWell(
            onTap: () {
              ref.read(settingsProvider.notifier).setLocale(locale);
            },
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: isSelected
                    ? Theme.of(context).primaryColor.withAlpha(25)
                    : Colors.transparent,
                border: isSelected
                    ? Border.all(color: Theme.of(context).primaryColor, width: 2)
                    : null,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    locale.flag,
                    style: TextStyle(
                      fontSize: 28,
                      // Add subtle opacity for unselected
                      color: isSelected ? null : Colors.black.withAlpha(180),
                    ),
                  ),
                  if (showLabels) ...[
                    const SizedBox(height: 2),
                    Text(
                      locale.code.toUpperCase(),
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        color: isSelected
                            ? Theme.of(context).primaryColor
                            : Theme.of(context).textTheme.bodySmall?.color,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
