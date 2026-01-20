import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../l10n/generated/app_localizations.dart';

/// Card displaying the connection theme (X-Y defined centers)
class ConnectionThemeCard extends StatelessWidget {
  const ConnectionThemeCard({
    super.key,
    required this.definedCount,
    required this.undefinedCount,
    required this.compatibilityScore,
  });

  final int definedCount;
  final int undefinedCount;
  final int compatibilityScore;

  String get connectionTheme => '$definedCount-$undefinedCount';

  String _getThemeDescription(AppLocalizations l10n) {
    // Based on number of defined centers when together
    if (definedCount >= 8) {
      return l10n.composite_themeVeryBonded;
    } else if (definedCount >= 6) {
      return l10n.composite_themeBonded;
    } else if (definedCount >= 4) {
      return l10n.composite_themeBalanced;
    } else if (definedCount >= 2) {
      return l10n.composite_themeIndependent;
    } else {
      return l10n.composite_themeVeryIndependent;
    }
  }

  Color _getScoreColor() {
    if (compatibilityScore >= 70) return AppColors.success;
    if (compatibilityScore >= 50) return AppColors.primary;
    if (compatibilityScore >= 30) return AppColors.warning;
    return AppColors.textSecondaryLight;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Connection theme circle
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.primary.withAlpha(50),
                    AppColors.secondary.withAlpha(50),
                  ],
                ),
                border: Border.all(
                  color: AppColors.primary.withAlpha(100),
                  width: 3,
                ),
              ),
              child: Center(
                child: Text(
                  connectionTheme,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Title
            Text(
              l10n.composite_connectionTheme,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),

            // Description based on defined centers
            Text(
              _getThemeDescription(l10n),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondaryLight,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),

            // Stats row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatItem(
                  context,
                  definedCount.toString(),
                  l10n.composite_definedCenters,
                  AppColors.primary,
                ),
                Container(
                  height: 40,
                  width: 1,
                  color: AppColors.textSecondaryLight.withAlpha(50),
                ),
                _buildStatItem(
                  context,
                  undefinedCount.toString(),
                  l10n.composite_undefinedCenters,
                  AppColors.secondary,
                ),
                Container(
                  height: 40,
                  width: 1,
                  color: AppColors.textSecondaryLight.withAlpha(50),
                ),
                _buildStatItem(
                  context,
                  '$compatibilityScore%',
                  l10n.composite_score,
                  _getScoreColor(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    String value,
    String label,
    Color color,
  ) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Text(
          value,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            color: AppColors.textSecondaryLight,
          ),
        ),
      ],
    );
  }
}
