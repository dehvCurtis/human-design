import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/composite_calculator.dart';

/// Card displaying a channel connection between two people
class ChannelConnectionCard extends StatelessWidget {
  const ChannelConnectionCard({
    super.key,
    required this.connection,
  });

  final ChannelConnection connection;

  Color _getTypeColor() {
    switch (connection.connectionType) {
      case ChannelConnectionType.electromagnetic:
        return AppColors.accent;
      case ChannelConnectionType.companionship:
        return AppColors.success;
      case ChannelConnectionType.dominance:
        return AppColors.warning;
      case ChannelConnectionType.compromise:
        return AppColors.info;
    }
  }

  IconData _getTypeIcon() {
    switch (connection.connectionType) {
      case ChannelConnectionType.electromagnetic:
        return Icons.electric_bolt;
      case ChannelConnectionType.companionship:
        return Icons.compare_arrows;
      case ChannelConnectionType.dominance:
        return Icons.school;
      case ChannelConnectionType.compromise:
        return Icons.balance;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final typeColor = _getTypeColor();

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Type icon
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: typeColor.withAlpha(25),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _getTypeIcon(),
                color: typeColor,
                size: 22,
              ),
            ),
            const SizedBox(width: 12),

            // Channel details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Channel name and ID
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: typeColor.withAlpha(25),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          connection.channelId,
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: typeColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          connection.channelName,
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),

                  // Who has which gates
                  _buildGateContributions(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGateContributions(BuildContext context) {
    final theme = Theme.of(context);

    String contributionText;
    switch (connection.connectionType) {
      case ChannelConnectionType.electromagnetic:
        final p1Gate = connection.person1Gates.isNotEmpty
            ? connection.person1Gates.first
            : '?';
        final p2Gate = connection.person2Gates.isNotEmpty
            ? connection.person2Gates.first
            : '?';
        contributionText =
            '${connection.person1Name}: Gate $p1Gate | ${connection.person2Name}: Gate $p2Gate';
        break;
      case ChannelConnectionType.companionship:
        contributionText =
            'Both ${connection.person1Name} & ${connection.person2Name} have this channel';
        break;
      case ChannelConnectionType.dominance:
        final whoHasChannel = connection.person1Gates.length == 2
            ? connection.person1Name
            : connection.person2Name;
        final whoDoesnt = connection.person1Gates.length == 2
            ? connection.person2Name
            : connection.person1Name;
        contributionText = '$whoHasChannel conditions $whoDoesnt';
        break;
      case ChannelConnectionType.compromise:
        final whoHasChannel = connection.person1Gates.length == 2
            ? connection.person1Name
            : connection.person2Name;
        final whoHasOne = connection.person1Gates.length == 2
            ? connection.person2Name
            : connection.person1Name;
        final singleGate = connection.person1Gates.length == 1
            ? connection.person1Gates.first
            : connection.person2Gates.first;
        contributionText =
            '$whoHasChannel has channel | $whoHasOne has Gate $singleGate';
        break;
    }

    return Text(
      contributionText,
      style: theme.textTheme.bodySmall?.copyWith(
        color: AppColors.textSecondaryLight,
      ),
    );
  }
}
