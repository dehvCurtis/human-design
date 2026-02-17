import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../lifestyle/domain/affirmation_service.dart';

/// Card displaying the daily affirmation
class AffirmationCard extends StatelessWidget {
  const AffirmationCard({
    super.key,
    required this.affirmation,
    this.onRefresh,
    this.onSave,
  });

  final DailyAffirmation affirmation;
  final VoidCallback? onRefresh;
  final VoidCallback? onSave;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.premiumGradientStart.withValues(alpha: 0.1),
              AppColors.premiumGradientEnd.withValues(alpha: 0.1),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.format_quote,
                      color: AppColors.primary,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.affirmation_title,
                          style:
                              Theme.of(context).textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        Text(
                          affirmation.sourceDescription,
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface
                                        .withValues(alpha: 0.6),
                                  ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Affirmation text
              Text(
                '"${affirmation.text}"',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontStyle: FontStyle.italic,
                      height: 1.5,
                    ),
              ),

              const SizedBox(height: 20),

              // Actions
              Wrap(
                alignment: WrapAlignment.end,
                spacing: 4,
                runSpacing: 4,
                children: [
                  TextButton.icon(
                    onPressed: () => _shareAffirmation(context),
                    icon: const Icon(Icons.share, size: 18),
                    label: Text(AppLocalizations.of(context)!.common_share),
                  ),
                  TextButton.icon(
                    onPressed: onSave,
                    icon: const Icon(Icons.bookmark_border, size: 18),
                    label: Text(AppLocalizations.of(context)!.common_save),
                  ),
                  IconButton(
                    onPressed: onRefresh,
                    icon: const Icon(Icons.refresh),
                    tooltip: AppLocalizations.of(context)!.affirmation_refresh,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _shareAffirmation(BuildContext context) {
    final text = '''
"${affirmation.text}"

${affirmation.sourceDescription}

- Inside Me: Human Design
''';
    SharePlus.instance.share(ShareParams(text: text));
  }
}
