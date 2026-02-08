import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../home/domain/home_providers.dart';
import '../../lifestyle/domain/transit_service.dart';
import '../domain/ai_providers.dart';

/// Screen showing AI-personalized transit insight for today
class AiTransitInsightScreen extends ConsumerStatefulWidget {
  const AiTransitInsightScreen({super.key});

  @override
  ConsumerState<AiTransitInsightScreen> createState() =>
      _AiTransitInsightScreenState();
}

class _AiTransitInsightScreenState
    extends ConsumerState<AiTransitInsightScreen> {
  bool _hasRequested = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final transits = ref.watch(todayTransitsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.ai_transitInsightTitle),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Transit summary header
            _buildTransitHeader(context, transits),
            const SizedBox(height: 16),

            // AI insight content
            if (!_hasRequested)
              _buildGenerateButton(context)
            else
              _buildInsightContent(context),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildTransitHeader(BuildContext context, TransitChart transits) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final sunGate = transits.sunGate;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.wb_sunny, color: Colors.amber, size: 24),
                const SizedBox(width: 8),
                Text(
                  'Sun Gate ${sunGate.gate}.${sunGate.line}',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              l10n.ai_transitInsightDesc,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGenerateButton(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Icon(
              Icons.auto_awesome,
              size: 48,
              color: AppColors.primary.withValues(alpha: 0.6),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.ai_transitInsightDesc,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: () {
                setState(() => _hasRequested = true);
              },
              icon: const Icon(Icons.auto_awesome),
              label: Text(l10n.ai_generating),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInsightContent(BuildContext context) {
    final insightAsync = ref.watch(transitInsightProvider);
    final l10n = AppLocalizations.of(context)!;

    return insightAsync.when(
      data: (message) {
        if (message == null) {
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(l10n.error_generic),
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: SelectableText(
                  message.content,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        height: 1.6,
                      ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: () {
                context.push(
                  AppRoutes.aiChat,
                );
              },
              icon: const Icon(Icons.chat_outlined),
              label: Text(l10n.ai_askFollowUp),
            ),
          ],
        );
      },
      loading: () => Card(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              Text(
                l10n.ai_generating,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
      error: (error, _) => Card(
        color: AppColors.error.withValues(alpha: 0.1),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Icon(Icons.error_outline, color: AppColors.error),
              const SizedBox(height: 8),
              Text(error.toString()),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => ref.invalidate(transitInsightProvider),
                child: Text(l10n.common_retry),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
