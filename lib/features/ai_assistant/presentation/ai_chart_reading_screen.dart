import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../chart/domain/models/human_design_chart.dart';
import '../../home/domain/home_providers.dart';
import '../../sharing/services/chart_export_service.dart';
import '../domain/ai_providers.dart';

/// Screen for comprehensive AI-generated chart reading
class AiChartReadingScreen extends ConsumerStatefulWidget {
  const AiChartReadingScreen({super.key});

  @override
  ConsumerState<AiChartReadingScreen> createState() =>
      _AiChartReadingScreenState();
}

class _AiChartReadingScreenState extends ConsumerState<AiChartReadingScreen> {
  bool _hasRequested = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final chartAsync = ref.watch(userChartProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.ai_chartReadingTitle),
        actions: [
          if (_hasRequested)
            IconButton(
              icon: const Icon(Icons.share),
              onPressed: () => _shareReading(context),
              tooltip: l10n.ai_shareReading,
            ),
        ],
      ),
      body: chartAsync.when(
        data: (chart) {
          if (chart == null) {
            return Center(child: Text(l10n.error_generic));
          }
          return _buildContent(context, chart);
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(e.toString())),
      ),
    );
  }

  Widget _buildContent(BuildContext context, HumanDesignChart chart) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Chart info header
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                    child: const Icon(Icons.auto_graph, color: AppColors.primary),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          chart.name,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${chart.type.displayName} | ${chart.profile.notation} | ${chart.authority.displayName}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Cost notice
          if (!_hasRequested) ...[
            Card(
              color: AppColors.warning.withValues(alpha: 0.1),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline, color: AppColors.warning, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        l10n.ai_chartReadingCost,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppColors.warning,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: () => setState(() => _hasRequested = true),
              icon: const Icon(Icons.auto_awesome),
              label: Text(l10n.ai_chartReadingTitle),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.all(16),
              ),
            ),
          ],

          // Reading content
          if (_hasRequested) _buildReadingContent(context),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildReadingContent(BuildContext context) {
    final readingAsync = ref.watch(chartReadingProvider);
    final l10n = AppLocalizations.of(context)!;

    return readingAsync.when(
      data: (message) {
        if (message == null) {
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(l10n.error_generic),
            ),
          );
        }

        // Parse sections from markdown
        final sections = _parseSections(message.content, l10n.ai_yourReading);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (final section in sections) _buildSectionCard(context, section),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: () => _exportPdf(context),
              icon: const Icon(Icons.picture_as_pdf),
              label: Text(l10n.ai_exportPdf),
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
              const SizedBox(height: 4),
              Text(
                'This may take a moment...',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withValues(alpha: 0.5),
                    ),
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
                onPressed: () => ref.invalidate(chartReadingProvider),
                child: Text(l10n.common_retry),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionCard(BuildContext context, _ReadingSection section) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ExpansionTile(
        title: Text(
          section.title,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        initiallyExpanded: true,
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        children: [
          SelectableText(
            section.content,
            style: theme.textTheme.bodyMedium?.copyWith(height: 1.6),
          ),
        ],
      ),
    );
  }

  List<_ReadingSection> _parseSections(String content, [String defaultTitle = 'Reading']) {
    final sections = <_ReadingSection>[];
    final lines = content.split('\n');
    String currentTitle = defaultTitle;
    final currentContent = StringBuffer();

    for (final line in lines) {
      if (line.startsWith('## ')) {
        // Save previous section
        if (currentContent.isNotEmpty) {
          sections.add(_ReadingSection(
            title: currentTitle,
            content: currentContent.toString().trim(),
          ));
          currentContent.clear();
        }
        currentTitle = line.substring(3).trim();
      } else {
        currentContent.writeln(line);
      }
    }

    // Add last section
    if (currentContent.isNotEmpty) {
      sections.add(_ReadingSection(
        title: currentTitle,
        content: currentContent.toString().trim(),
      ));
    }

    // If no sections were parsed, wrap entire content as one
    if (sections.isEmpty) {
      sections.add(_ReadingSection(
        title: defaultTitle,
        content: content.trim(),
      ));
    }

    return sections;
  }

  void _shareReading(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final reading = ref.read(chartReadingProvider);
    reading.whenData((message) {
      if (message != null) {
        // Use share_plus through chart export service
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.ai_sharingReading)),
        );
      }
    });
  }

  void _exportPdf(BuildContext context) async {
    final chart = await ref.read(userChartProvider.future);
    if (chart == null || !context.mounted) return;

    final reading = ref.read(chartReadingProvider);
    reading.whenData((message) {
      if (message != null && context.mounted) {
        ChartExportService.exportReadingAsPdf(
          chart: chart,
          aiReadingText: message.content,
          context: context,
        );
      }
    });
  }
}

class _ReadingSection {
  const _ReadingSection({required this.title, required this.content});
  final String title;
  final String content;
}
