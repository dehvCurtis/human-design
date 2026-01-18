import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/penta_calculator.dart';

/// Card displaying a Penta role and its status
class PentaRoleCard extends StatelessWidget {
  const PentaRoleCard({
    super.key,
    required this.role,
    this.roleInfo,
  });

  final PentaRole role;
  final PentaRoleInfo? roleInfo;

  bool get isFilled => roleInfo != null;
  bool get isComplete => roleInfo?.isComplete ?? false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = _getRoleColor();

    return Card(
      elevation: isComplete ? 2 : 0,
      color: isFilled ? color.withAlpha(25) : theme.colorScheme.surfaceContainerHighest,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isComplete ? color : color.withAlpha(100),
          width: isComplete ? 2 : 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: color.withAlpha(50),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    _getRoleIcon(),
                    color: color,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        role.displayName,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: isComplete ? color : null,
                        ),
                      ),
                      Text(
                        _getStatusText(),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: isComplete
                              ? AppColors.success
                              : AppColors.textSecondaryLight,
                        ),
                      ),
                    ],
                  ),
                ),
                _buildStatusBadge(context),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              role.description,
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondaryLight,
              ),
            ),
            if (roleInfo != null && roleInfo!.contributors.isNotEmpty) ...[
              const SizedBox(height: 12),
              Wrap(
                spacing: 4,
                runSpacing: 4,
                children: roleInfo!.contributorNames.map((name) {
                  return Chip(
                    label: Text(
                      name,
                      style: theme.textTheme.labelSmall,
                    ),
                    visualDensity: VisualDensity.compact,
                    padding: EdgeInsets.zero,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    backgroundColor: color.withAlpha(30),
                    side: BorderSide.none,
                  );
                }).toList(),
              ),
            ],
            if (roleInfo != null && !isComplete && roleInfo!.missingGate != null) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.warning.withAlpha(25),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'Missing Gate ${roleInfo!.missingGate}',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: AppColors.warning,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(BuildContext context) {
    if (isComplete) {
      return Container(
        padding: const EdgeInsets.all(4),
        decoration: const BoxDecoration(
          color: AppColors.success,
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.check,
          color: Colors.white,
          size: 16,
        ),
      );
    } else if (isFilled) {
      return Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: AppColors.warning.withAlpha(50),
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.hourglass_empty,
          color: AppColors.warning,
          size: 16,
        ),
      );
    } else {
      return Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: AppColors.textSecondaryLight.withAlpha(50),
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.remove,
          color: AppColors.textSecondaryLight,
          size: 16,
        ),
      );
    }
  }

  String _getStatusText() {
    if (isComplete) {
      return 'Complete';
    } else if (isFilled) {
      return 'Partial';
    }
    return 'Missing';
  }

  Color _getRoleColor() {
    switch (role) {
      case PentaRole.guide:
        return AppColors.primary;
      case PentaRole.provider:
        return AppColors.success;
      case PentaRole.administrator:
        return AppColors.info;
      case PentaRole.coordinator:
        return AppColors.accent;
      case PentaRole.evaluator:
        return AppColors.secondary;
    }
  }

  IconData _getRoleIcon() {
    switch (role) {
      case PentaRole.guide:
        return Icons.navigation_outlined;
      case PentaRole.provider:
        return Icons.inventory_2_outlined;
      case PentaRole.administrator:
        return Icons.admin_panel_settings_outlined;
      case PentaRole.coordinator:
        return Icons.hub_outlined;
      case PentaRole.evaluator:
        return Icons.assessment_outlined;
    }
  }
}
