import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../core/theme/app_colors.dart';
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
              AppColors.premiumGradientStart.withOpacity(0.1),
              AppColors.premiumGradientEnd.withOpacity(0.1),
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
                      color: AppColors.primary.withOpacity(0.1),
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
                          'Daily Affirmation',
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
                                        .withOpacity(0.6),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton.icon(
                    onPressed: () => _shareAffirmation(context),
                    icon: const Icon(Icons.share, size: 18),
                    label: const Text('Share'),
                  ),
                  const SizedBox(width: 8),
                  TextButton.icon(
                    onPressed: onSave,
                    icon: const Icon(Icons.bookmark_border, size: 18),
                    label: const Text('Save'),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: onRefresh,
                    icon: const Icon(Icons.refresh),
                    tooltip: 'New affirmation',
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

- Human Design App
''';
    Share.share(text);
  }
}
