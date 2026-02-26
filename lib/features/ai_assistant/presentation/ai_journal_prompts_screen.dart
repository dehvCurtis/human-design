import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_colors.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../dream_journal/domain/dream_providers.dart';
import '../../dream_journal/domain/models/journal_entry.dart';
import '../../home/domain/home_providers.dart';
import '../domain/ai_providers.dart';

/// Screen showing daily AI-generated journaling prompts
class AiJournalPromptsScreen extends ConsumerStatefulWidget {
  const AiJournalPromptsScreen({super.key});

  @override
  ConsumerState<AiJournalPromptsScreen> createState() =>
      _AiJournalPromptsScreenState();
}

class _AiJournalPromptsScreenState
    extends ConsumerState<AiJournalPromptsScreen> {
  bool _hasRequested = false;
  final Map<int, TextEditingController> _controllers = {};
  final Map<int, bool> _expandedPrompts = {};

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final transits = ref.watch(todayTransitsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.ai_journalPromptsTitle),
        actions: [
          if (_hasRequested)
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                ref.invalidate(journalingPromptsProvider);
              },
              tooltip: l10n.ai_regenerate,
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Transit context header
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(Icons.wb_sunny, color: Colors.amber, size: 24),
                    const SizedBox(width: 8),
                    Text(
                      'Sun Gate ${transits.sunGate.gate}.${transits.sunGate.line}',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            if (!_hasRequested)
              _buildGenerateButton(context)
            else
              _buildPromptsContent(context),

            const SizedBox(height: 24),

            // Past journal entries
            _buildPastEntries(context),

            const SizedBox(height: 32),
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
              Icons.edit_note,
              size: 48,
              color: AppColors.primary.withValues(alpha: 0.6),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.ai_journalPromptsDesc,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: () {
                ref.invalidate(journalingPromptsProvider);
                setState(() => _hasRequested = true);
              },
              icon: const Icon(Icons.auto_awesome),
              label: Text(l10n.ai_journalPromptsTitle),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPromptsContent(BuildContext context) {
    final promptsAsync = ref.watch(journalingPromptsProvider);
    final l10n = AppLocalizations.of(context)!;

    return promptsAsync.when(
      data: (message) {
        if (message == null) {
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(l10n.error_generic),
            ),
          );
        }

        final prompts = _parsePrompts(message.content);

        return Column(
          children: [
            for (int i = 0; i < prompts.length; i++)
              _buildPromptCard(context, i, prompts[i]),
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
              Text(l10n.ai_generating),
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
                onPressed: () => ref.invalidate(journalingPromptsProvider),
                child: Text(l10n.common_retry),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPromptCard(BuildContext context, int index, String prompt) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final isExpanded = _expandedPrompts[index] ?? false;
    _controllers.putIfAbsent(index, () => TextEditingController());

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: () {
                setState(() {
                  _expandedPrompts[index] = !isExpanded;
                });
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 14,
                    backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                    child: Text(
                      '${index + 1}',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      prompt,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        height: 1.5,
                      ),
                    ),
                  ),
                  Icon(
                    isExpanded ? Icons.expand_less : Icons.expand_more,
                    color: AppColors.primary,
                  ),
                ],
              ),
            ),
            if (isExpanded) ...[
              const SizedBox(height: 12),
              TextField(
                controller: _controllers[index],
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context)!.ai_writeThoughts,
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: FilledButton.tonalIcon(
                  onPressed: () => _saveEntry(index, prompt),
                  icon: const Icon(Icons.save, size: 18),
                  label: Text(l10n.common_save),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _saveEntry(int index, String prompt) async {
    final content = _controllers[index]?.text.trim() ?? '';
    if (content.isEmpty) return;

    final transits = ref.read(todayTransitsProvider);
    final dreamRepo = ref.read(dreamRepositoryProvider);

    await dreamRepo.createEntry(
      content: content,
      entryType: JournalEntryType.journal,
      transitSunGate: transits.sunGate.gate,
      prompt: prompt,
    );

    ref.invalidate(journalEntriesProvider);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.ai_entrySaved)),
      );
      _controllers[index]?.clear();
      setState(() {
        _expandedPrompts[index] = false;
      });
    }
  }

  Widget _buildPastEntries(BuildContext context) {
    final entriesAsync = ref.watch(journalEntriesProvider);
    final theme = Theme.of(context);

    return entriesAsync.when(
      data: (entries) {
        if (entries.isEmpty) return const SizedBox.shrink();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Divider(),
            const SizedBox(height: 8),
            Text(
              AppLocalizations.of(context)!.ai_pastEntries,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            for (final entry in entries) _buildPastEntryCard(context, entry),
          ],
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
    );
  }

  Widget _buildPastEntryCard(BuildContext context, JournalEntry entry) {
    final theme = Theme.of(context);
    final dateStr = DateFormat.yMMMd().add_jm().format(entry.createdAt.toLocal());

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.edit_note, size: 16, color: AppColors.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    dateStr,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                if (entry.transitSunGate != null)
                  Text(
                    'Gate ${entry.transitSunGate}',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: Colors.amber.shade700,
                    ),
                  ),
              ],
            ),
            if (entry.prompt != null) ...[
              const SizedBox(height: 8),
              Text(
                entry.prompt!,
                style: theme.textTheme.bodySmall?.copyWith(
                  fontStyle: FontStyle.italic,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
            const SizedBox(height: 8),
            Text(
              entry.content,
              style: theme.textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

  List<String> _parsePrompts(String content) {
    final prompts = <String>[];
    final lines = content.split('\n');

    for (final line in lines) {
      final trimmed = line.trim();
      if (trimmed.isEmpty) continue;

      // Match numbered prompts like "1.", "1)", "1:"
      final match = RegExp(r'^\d+[.):\s](.+)').firstMatch(trimmed);
      if (match != null) {
        prompts.add(match.group(1)!.trim());
      } else if (trimmed.startsWith('- ') || trimmed.startsWith('* ')) {
        prompts.add(trimmed.substring(2).trim());
      }
    }

    // Fallback: if parsing failed, split by newlines
    if (prompts.isEmpty) {
      for (final line in lines) {
        final trimmed = line.trim();
        if (trimmed.isNotEmpty) {
          prompts.add(trimmed);
        }
      }
    }

    return prompts;
  }
}
