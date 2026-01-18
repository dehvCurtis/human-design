import 'package:flutter/material.dart';

import '../../domain/models/sharing.dart';

/// Compatibility report card widget for displaying relationship dynamics
class CompatibilityReportCard extends StatelessWidget {
  const CompatibilityReportCard({
    super.key,
    required this.report,
    this.showWatermark = true,
  });

  final CompatibilityReport report;
  final bool showWatermark;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: 420,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(theme),
          const SizedBox(height: 20),
          _buildOverallScore(theme),
          const SizedBox(height: 20),
          _buildPersonComparison(theme),
          const SizedBox(height: 20),
          _buildCompatibilitySections(theme),
          if (report.electromagneticChannels.isNotEmpty) ...[
            const SizedBox(height: 16),
            _buildChannelsSection(theme),
          ],
          if (report.insights.isNotEmpty) ...[
            const SizedBox(height: 16),
            _buildInsightsSection(theme),
          ],
          if (report.strengths.isNotEmpty || report.challenges.isNotEmpty) ...[
            const SizedBox(height: 16),
            _buildStrengthsChallenges(theme),
          ],
          if (showWatermark) ...[
            const SizedBox(height: 20),
            _buildWatermark(theme),
          ],
        ],
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Row(
      children: [
        Icon(
          Icons.favorite,
          color: theme.colorScheme.primary,
          size: 28,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Compatibility Report',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Human Design Connection Analysis',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOverallScore(ThemeData theme) {
    final scoreColor = _getScoreColor(report.overallScore);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            scoreColor.withValues(alpha: 0.2),
            scoreColor.withValues(alpha: 0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: scoreColor.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 80,
                height: 80,
                child: CircularProgressIndicator(
                  value: report.overallScore / 100,
                  strokeWidth: 8,
                  backgroundColor: scoreColor.withValues(alpha: 0.2),
                  valueColor: AlwaysStoppedAnimation<Color>(scoreColor),
                ),
              ),
              Text(
                '${report.overallScore}',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: scoreColor,
                ),
              ),
            ],
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getScoreLabel(report.overallScore),
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: scoreColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _getScoreDescription(report.overallScore),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonComparison(ThemeData theme) {
    return Row(
      children: [
        Expanded(child: _buildPersonCard(theme, report.person1, true)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Icon(
            Icons.compare_arrows,
            color: theme.colorScheme.primary,
          ),
        ),
        Expanded(child: _buildPersonCard(theme, report.person2, false)),
      ],
    );
  }

  Widget _buildPersonCard(ThemeData theme, ChartSummaryData person, bool isLeft) {
    final typeColor = _getTypeColor(person.type);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: typeColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: typeColor.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: isLeft ? CrossAxisAlignment.start : CrossAxisAlignment.end,
        children: [
          Text(
            person.name,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: isLeft ? TextAlign.left : TextAlign.right,
          ),
          const SizedBox(height: 4),
          Text(
            person.type,
            style: theme.textTheme.bodySmall?.copyWith(
              color: typeColor,
              fontWeight: FontWeight.w500,
            ),
            textAlign: isLeft ? TextAlign.left : TextAlign.right,
          ),
          Text(
            person.profile,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
            textAlign: isLeft ? TextAlign.left : TextAlign.right,
          ),
        ],
      ),
    );
  }

  Widget _buildCompatibilitySections(ThemeData theme) {
    return Column(
      children: [
        _buildScoreRow(
          theme,
          'Type Compatibility',
          report.typeCompatibility.score,
          25,
          report.typeCompatibility.description,
          Icons.category_outlined,
        ),
        const SizedBox(height: 12),
        _buildScoreRow(
          theme,
          'Profile Harmonics',
          report.profileHarmonics.score,
          25,
          report.profileHarmonics.description,
          Icons.people_outline,
        ),
      ],
    );
  }

  Widget _buildScoreRow(
    ThemeData theme,
    String title,
    int score,
    int maxScore,
    String description,
    IconData icon,
  ) {
    final percentage = score / maxScore;
    final color = _getScoreColor((percentage * 100).round());

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: color),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Text(
                '$score/$maxScore',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: percentage,
              backgroundColor: color.withValues(alpha: 0.2),
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 6,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            description,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChannelsSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.bolt,
              size: 18,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(width: 8),
            Text(
              'Electromagnetic Channels',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: report.electromagneticChannels.map((channel) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.flash_on,
                    size: 14,
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    channel,
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: theme.colorScheme.onPrimaryContainer,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 8),
        Text(
          'These channels create natural attraction and energy exchange between you.',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }

  Widget _buildInsightsSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.lightbulb_outline,
              size: 18,
              color: Colors.amber,
            ),
            const SizedBox(width: 8),
            Text(
              'Key Insights',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ...report.insights.map((insight) => Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 6),
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: Colors.amber,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  insight,
                  style: theme.textTheme.bodySmall,
                ),
              ),
            ],
          ),
        )),
      ],
    );
  }

  Widget _buildStrengthsChallenges(ThemeData theme) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (report.strengths.isNotEmpty)
          Expanded(
            child: _buildListSection(
              theme,
              'Strengths',
              report.strengths,
              Colors.green,
              Icons.thumb_up_outlined,
            ),
          ),
        if (report.strengths.isNotEmpty && report.challenges.isNotEmpty)
          const SizedBox(width: 12),
        if (report.challenges.isNotEmpty)
          Expanded(
            child: _buildListSection(
              theme,
              'Growth Areas',
              report.challenges,
              Colors.orange,
              Icons.trending_up,
            ),
          ),
      ],
    );
  }

  Widget _buildListSection(
    ThemeData theme,
    String title,
    List<String> items,
    Color color,
    IconData icon,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 6),
            Text(
              title,
              style: theme.textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ...items.take(2).map((item) => Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Text(
            '• ${item.length > 50 ? '${item.substring(0, 50)}...' : item}',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        )),
      ],
    );
  }

  Widget _buildWatermark(ThemeData theme) {
    return Center(
      child: Text(
        'humandesign.app',
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Color _getScoreColor(int score) {
    if (score >= 80) return Colors.green;
    if (score >= 60) return Colors.lightGreen;
    if (score >= 40) return Colors.orange;
    return Colors.red;
  }

  String _getScoreLabel(int score) {
    if (score >= 80) return 'Excellent Match';
    if (score >= 60) return 'Good Compatibility';
    if (score >= 40) return 'Moderate Match';
    return 'Growth Opportunity';
  }

  String _getScoreDescription(int score) {
    if (score >= 80) {
      return 'Strong natural alignment and complementary energies.';
    }
    if (score >= 60) {
      return 'Positive dynamics with some areas for growth.';
    }
    if (score >= 40) {
      return 'Balance of harmony and learning opportunities.';
    }
    return 'Significant growth potential through conscious awareness.';
  }

  Color _getTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'generator':
        return const Color(0xFFE57373);
      case 'manifesting generator':
        return const Color(0xFFFF8A65);
      case 'projector':
        return const Color(0xFF64B5F6);
      case 'manifestor':
        return const Color(0xFFBA68C8);
      case 'reflector':
        return const Color(0xFF81C784);
      default:
        return const Color(0xFF90A4AE);
    }
  }
}

/// Compact compatibility summary for list views
class CompatibilitySummaryCard extends StatelessWidget {
  const CompatibilitySummaryCard({
    super.key,
    required this.person1Name,
    required this.person2Name,
    required this.score,
    this.onTap,
  });

  final String person1Name;
  final String person2Name;
  final int score;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scoreColor = _getScoreColor(score);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: theme.colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: scoreColor.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '$score',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: scoreColor,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$person1Name & $person2Name',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    _getScoreLabel(score),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: scoreColor,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
            ),
          ],
        ),
      ),
    );
  }

  Color _getScoreColor(int score) {
    if (score >= 80) return Colors.green;
    if (score >= 60) return Colors.lightGreen;
    if (score >= 40) return Colors.orange;
    return Colors.red;
  }

  String _getScoreLabel(int score) {
    if (score >= 80) return 'Excellent Match';
    if (score >= 60) return 'Good Compatibility';
    if (score >= 40) return 'Moderate Match';
    return 'Growth Opportunity';
  }
}
