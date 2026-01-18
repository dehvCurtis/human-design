import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/penta_calculator.dart';

/// Card displaying an electromagnetic connection between two members
class ConnectionCard extends StatelessWidget {
  const ConnectionCard({
    super.key,
    required this.connection,
  });

  final ElectromagneticConnection connection;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Member avatars
            _buildConnectionAvatars(context),
            const SizedBox(width: 12),

            // Connection details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${connection.member1.name} & ${connection.member2.name}',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${connection.channels.length} electromagnetic channel${connection.channels.length > 1 ? 's' : ''}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondaryLight,
                    ),
                  ),
                  if (connection.channels.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 4,
                      runSpacing: 4,
                      children: connection.channels.map((channel) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.accent.withAlpha(25),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${channel.gate1}-${channel.gate2}',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: AppColors.accent,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ],
              ),
            ),

            // Connection icon
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.accent.withAlpha(25),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.electric_bolt,
                color: AppColors.accent,
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConnectionAvatars(BuildContext context) {
    return SizedBox(
      width: 50,
      height: 40,
      child: Stack(
        children: [
          Positioned(
            left: 0,
            child: CircleAvatar(
              radius: 18,
              backgroundColor: AppColors.primary.withAlpha(50),
              child: Text(
                connection.member1.name.isNotEmpty
                    ? connection.member1.name[0].toUpperCase()
                    : '?',
                style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Positioned(
            left: 16,
            child: CircleAvatar(
              radius: 18,
              backgroundColor: AppColors.secondary.withAlpha(50),
              child: Text(
                connection.member2.name.isNotEmpty
                    ? connection.member2.name[0].toUpperCase()
                    : '?',
                style: const TextStyle(
                  color: AppColors.secondary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
