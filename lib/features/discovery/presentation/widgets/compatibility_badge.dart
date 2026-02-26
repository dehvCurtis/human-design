import 'package:flutter/material.dart';

import '../../../../l10n/generated/app_localizations.dart';
import '../../domain/models/user_discovery.dart';

class CompatibilityBadge extends StatelessWidget {
  const CompatibilityBadge({
    super.key,
    required this.score,
    this.details,
    this.showDetails = false,
  });

  final int score;
  final CompatibilityDetails? details;
  final bool showDetails;

  @override
  Widget build(BuildContext context) {
    final color = _getScoreColor(score);
    final label = _getScoreLabel(score);

    if (showDetails && details != null) {
      return _DetailedCompatibilityCard(score: score, details: details!);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withValues(alpha: 0.15),
            color.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _getScoreIcon(score),
            size: 14,
            color: color,
          ),
          const SizedBox(width: 4),
          Text(
            '$score%',
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: color.withValues(alpha: 0.8),
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  Color _getScoreColor(int score) {
    if (score >= 80) return Colors.green;
    if (score >= 60) return Colors.teal;
    if (score >= 40) return Colors.amber;
    if (score >= 20) return Colors.orange;
    return Colors.grey;
  }

  String _getScoreLabel(int score) {
    if (score >= 80) return 'Excellent';
    if (score >= 60) return 'Good';
    if (score >= 40) return 'Moderate';
    if (score >= 20) return 'Low';
    return 'Minimal';
  }

  IconData _getScoreIcon(int score) {
    if (score >= 80) return Icons.star;
    if (score >= 60) return Icons.thumb_up_outlined;
    if (score >= 40) return Icons.handshake_outlined;
    return Icons.compare_arrows;
  }
}

class _DetailedCompatibilityCard extends StatelessWidget {
  const _DetailedCompatibilityCard({
    required this.score,
    required this.details,
  });

  final int score;
  final CompatibilityDetails details;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final color = _getScoreColor(score);

    return Card(
      elevation: 0,
      color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Overall score
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                    border: Border.all(color: color, width: 2),
                  ),
                  child: Center(
                    child: Text(
                      '$score',
                      style: TextStyle(
                        color: color,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Compatibility Score',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        _getOverallDescription(score),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 12),

            // Score breakdown
            _ScoreBar(
              label: l10n.discovery_typeCompatibility,
              score: details.typeScore,
              maxScore: 25,
              description: details.typeCompatibility,
            ),
            const SizedBox(height: 8),
            _ScoreBar(
              label: l10n.discovery_profileHarmonics,
              score: details.profileScore,
              maxScore: 25,
              description: details.profileHarmonics,
            ),
            const SizedBox(height: 8),
            _ScoreBar(
              label: l10n.discovery_channelComplementarity,
              score: details.channelScore,
              maxScore: 25,
              description: details.complementaryChannels?.isNotEmpty == true
                  ? '${details.complementaryChannels!.length} electromagnetic channels'
                  : null,
            ),
            const SizedBox(height: 8),
            _ScoreBar(
              label: l10n.discovery_definitionBridging,
              score: details.definitionScore,
              maxScore: 25,
              description: details.bridgingOpportunities?.isNotEmpty == true
                  ? '${details.bridgingOpportunities!.length} bridging opportunities'
                  : null,
            ),

            // Electromagnetic channels
            if (details.complementaryChannels?.isNotEmpty == true) ...[
              const SizedBox(height: 16),
              Text(
                'Electromagnetic Channels',
                style: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: details.complementaryChannels!
                    .map((channel) => Chip(
                          label: Text(channel),
                          labelStyle: const TextStyle(fontSize: 11),
                          padding: EdgeInsets.zero,
                          visualDensity: VisualDensity.compact,
                        ))
                    .toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color _getScoreColor(int score) {
    if (score >= 80) return Colors.green;
    if (score >= 60) return Colors.teal;
    if (score >= 40) return Colors.amber;
    if (score >= 20) return Colors.orange;
    return Colors.grey;
  }

  String _getOverallDescription(int score) {
    if (score >= 80) return 'Highly compatible energies with natural flow';
    if (score >= 60) return 'Good compatibility with growth potential';
    if (score >= 40) return 'Moderate compatibility, some adjustments needed';
    if (score >= 20) return 'Different energies, requires understanding';
    return 'Very different designs, unique dynamic';
  }
}

class _ScoreBar extends StatelessWidget {
  const _ScoreBar({
    required this.label,
    required this.score,
    required this.maxScore,
    this.description,
  });

  final String label;
  final int score;
  final int maxScore;
  final String? description;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final percentage = score / maxScore;
    final color = _getBarColor(percentage);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: theme.textTheme.bodySmall,
            ),
            Text(
              '$score/$maxScore',
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: percentage,
            backgroundColor: theme.colorScheme.surfaceContainerHighest,
            valueColor: AlwaysStoppedAnimation(color),
            minHeight: 6,
          ),
        ),
        if (description != null) ...[
          const SizedBox(height: 2),
          Text(
            description!,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              fontSize: 10,
            ),
          ),
        ],
      ],
    );
  }

  Color _getBarColor(double percentage) {
    if (percentage >= 0.8) return Colors.green;
    if (percentage >= 0.6) return Colors.teal;
    if (percentage >= 0.4) return Colors.amber;
    if (percentage >= 0.2) return Colors.orange;
    return Colors.grey;
  }
}

/// A dialog showing full compatibility breakdown between two users
class CompatibilityDialog extends StatelessWidget {
  const CompatibilityDialog({
    super.key,
    required this.userName,
    required this.score,
    required this.details,
  });

  final String userName;
  final int score;
  final CompatibilityDetails details;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Compatibility with $userName',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _DetailedCompatibilityCard(score: score, details: details),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
