import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/theme/app_colors.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../ai_assistant/data/ai_repository.dart';
import '../../ai_assistant/domain/ai_providers.dart';
import '../../feed/domain/models/post.dart';
import '../../feed/presentation/widgets/create_post_sheet.dart';
import '../../home/domain/home_providers.dart';
import '../domain/dream_providers.dart';
import '../domain/models/journal_entry.dart';

/// Screen for entering a new dream and getting AI interpretation
class DreamEntryScreen extends ConsumerStatefulWidget {
  const DreamEntryScreen({super.key});

  @override
  ConsumerState<DreamEntryScreen> createState() => _DreamEntryScreenState();
}

class _DreamEntryScreenState extends ConsumerState<DreamEntryScreen> {
  final _controller = TextEditingController();
  bool _isInterpreting = false;
  String? _interpretation;
  String? _error;
  bool _isSaved = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _interpretDream() async {
    final dreamText = _controller.text.trim();
    if (dreamText.isEmpty) return;

    setState(() {
      _isInterpreting = true;
      _error = null;
    });

    try {
      final chart = await ref.read(userChartProvider.future);
      if (chart == null) {
        setState(() {
          _error = 'Chart not available';
          _isInterpreting = false;
        });
        return;
      }

      final transits = ref.read(todayTransitsProvider);
      final impact = await ref.read(transitImpactProvider.future);
      final repository = ref.read(aiRepositoryProvider);

      final message = await repository.interpretDream(
        dreamText: dreamText,
        chart: chart,
        transits: transits,
        impact: impact,
      );

      if (mounted) {
        setState(() {
          _interpretation = message.content;
          _isInterpreting = false;
        });
        ref.invalidate(aiUsageProvider);

        // Save to database (separate try/catch so interpretation still shows on save failure)
        try {
          final sunGate = transits.sunGate.gate;
          final dreamRepo = ref.read(dreamRepositoryProvider);
          final entry = await dreamRepo.createEntry(
            content: dreamText,
            entryType: JournalEntryType.dream,
            transitSunGate: sunGate,
          );
          await dreamRepo.updateInterpretation(
            entryId: entry.id,
            aiInterpretation: message.content,
            conversationId: message.conversationId,
          );
          if (mounted) {
            setState(() => _isSaved = true);
            ref.invalidate(dreamEntriesProvider);
          }
        } catch (saveError) {
          debugPrint('Dream save error: $saveError');
          // Interpretation succeeded, just couldn't save - don't show error
        }
      }
    } on AiServiceException catch (e) {
      if (mounted) {
        setState(() {
          _error = e.message;
          _isInterpreting = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Failed to interpret dream. Please try again.';
          _isInterpreting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.ai_interpretDream),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Dream input
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.nights_stay, color: AppColors.primary),
                        const SizedBox(width: 8),
                        Text(
                          l10n.ai_dreamJournalTitle,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _controller,
                      maxLines: 8,
                      maxLength: 1000,
                      enabled: !_isInterpreting && _interpretation == null,
                      decoration: InputDecoration(
                        hintText: l10n.ai_dreamEntryHint,
                        border: const OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Interpret button
            if (_interpretation == null)
              FilledButton.icon(
                onPressed: _isInterpreting || _controller.text.trim().isEmpty
                    ? null
                    : _interpretDream,
                icon: _isInterpreting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.auto_awesome),
                label: Text(
                  _isInterpreting ? l10n.ai_generating : l10n.ai_interpretDream,
                ),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                ),
              ),

            // Error
            if (_error != null) ...[
              const SizedBox(height: 12),
              Card(
                color: AppColors.error.withValues(alpha: 0.1),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline, color: AppColors.error, size: 20),
                      const SizedBox(width: 8),
                      Expanded(child: Text(_error!)),
                    ],
                  ),
                ),
              ),
            ],

            // Interpretation result
            if (_interpretation != null) ...[
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.auto_awesome, color: AppColors.primary, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            'AI Interpretation',
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                          const Spacer(),
                          if (_isSaved)
                            Icon(
                              Icons.check_circle,
                              color: AppColors.success,
                              size: 20,
                            ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      SelectableText(
                        _interpretation!,
                        style: theme.textTheme.bodyMedium?.copyWith(height: 1.6),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        final dreamText = _controller.text.trim();
                        final content =
                            'Dream:\n$dreamText\n\nAI Interpretation:\n${_interpretation!}';
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          builder: (context) => CreatePostSheet(
                            initialPostType: PostType.dreamShare,
                            prefillContent: content,
                            gateNumber:
                                ref.read(todayTransitsProvider).sunGate.gate,
                          ),
                        );
                      },
                      icon: const Icon(Icons.forum_outlined, size: 18),
                      label: const Text('Share to Feed'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        final dreamText = _controller.text.trim();
                        final text =
                            'My Dream:\n$dreamText\n\nAI Interpretation:\n${_interpretation!}\n\nShared from Inside Me: Human Design';
                        SharePlus.instance.share(ShareParams(text: text));
                      },
                      icon: const Icon(Icons.share_outlined, size: 18),
                      label: const Text('Share'),
                    ),
                  ),
                ],
              ),
            ],

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
