import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../chart/domain/models/human_design_chart.dart';
import '../../composite/domain/composite_calculator.dart';
import '../data/ai_repository.dart';
import '../domain/ai_providers.dart';
import '../domain/models/ai_message.dart';

/// Screen for AI-powered compatibility analysis between two charts
class AiCompatibilityScreen extends ConsumerStatefulWidget {
  const AiCompatibilityScreen({
    super.key,
    required this.person1,
    required this.person2,
    required this.compositeResult,
  });

  final HumanDesignChart person1;
  final HumanDesignChart person2;
  final CompositeResult compositeResult;

  @override
  ConsumerState<AiCompatibilityScreen> createState() =>
      _AiCompatibilityScreenState();
}

class _AiCompatibilityScreenState
    extends ConsumerState<AiCompatibilityScreen> {
  AiMessage? _reading;
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _generateReading();
  }

  Future<void> _generateReading() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final repository = ref.read(aiRepositoryProvider);
      final message = await repository.getCompatibilityReading(
        person1: widget.person1,
        person2: widget.person2,
        report: widget.compositeResult,
      );
      if (mounted) {
        setState(() {
          _reading = message;
          _isLoading = false;
        });
        ref.invalidate(aiUsageProvider);
      }
    } on AiServiceException catch (e) {
      if (mounted) {
        setState(() {
          _error = e.message;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Failed to generate reading. Please try again.';
          _isLoading = false;
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
        title: Text(l10n.ai_compatibilityTitle),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // People header
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          CircleAvatar(
                            backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                            child: Text(widget.person1.name.isNotEmpty
                                ? widget.person1.name[0].toUpperCase()
                                : '?'),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.person1.type.displayName,
                            style: theme.textTheme.bodySmall,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.accent.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '${widget.compositeResult.compatibilityScore}%',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.accent,
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Icon(Icons.favorite, color: AppColors.accent, size: 16),
                      ],
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          CircleAvatar(
                            backgroundColor: AppColors.secondary.withValues(alpha: 0.1),
                            child: Text(widget.person2.name.isNotEmpty
                                ? widget.person2.name[0].toUpperCase()
                                : '?'),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.person2.type.displayName,
                            style: theme.textTheme.bodySmall,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // AI Reading
            if (_isLoading)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    children: [
                      const CircularProgressIndicator(),
                      const SizedBox(height: 16),
                      Text(
                        l10n.ai_generating,
                        style: theme.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              )
            else if (_error != null)
              Card(
                color: AppColors.error.withValues(alpha: 0.1),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      const Icon(Icons.error_outline, color: AppColors.error),
                      const SizedBox(height: 8),
                      Text(_error!),
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed: _generateReading,
                        child: Text(l10n.common_retry),
                      ),
                    ],
                  ),
                ),
              )
            else if (_reading != null)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: SelectableText(
                    _reading!.content,
                    style: theme.textTheme.bodyLarge?.copyWith(height: 1.6),
                  ),
                ),
              ),

            const SizedBox(height: 16),

            // Follow-up button
            if (_reading != null)
              OutlinedButton.icon(
                onPressed: () => context.push(AppRoutes.aiChat),
                icon: const Icon(Icons.chat_outlined),
                label: Text(l10n.ai_askFollowUp),
              ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
