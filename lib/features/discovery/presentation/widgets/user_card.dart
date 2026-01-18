import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/user_discovery.dart';
import '../../domain/discovery_providers.dart';
import 'compatibility_badge.dart';

class UserCard extends ConsumerWidget {
  const UserCard({
    super.key,
    required this.user,
    required this.onTap,
    this.showFollowBack = false,
    this.showCompatibility = false,
  });

  final DiscoveredUser user;
  final VoidCallback onTap;
  final bool showFollowBack;
  final bool showCompatibility;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final followState = ref.watch(followNotifierProvider);
    final isFollowing = followState[user.id] ?? user.isFollowing;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Avatar
              _UserAvatar(
                avatarUrl: user.avatarUrl,
                name: user.name,
                hdType: user.hdType,
              ),
              const SizedBox(width: 12),

              // User info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name and mutual follow indicator
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            user.name,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (user.isMutualFollow)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primaryContainer,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'Mutual',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: theme.colorScheme.onPrimaryContainer,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 2),

                    // HD Type and Profile
                    if (user.hdType != null || user.hdProfile != null)
                      Row(
                        children: [
                          if (user.hdType != null) ...[
                            _TypeChip(type: user.hdType!),
                            const SizedBox(width: 8),
                          ],
                          if (user.hdProfile != null)
                            Text(
                              user.hdProfile!,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurface
                                    .withValues(alpha: 0.6),
                              ),
                            ),
                        ],
                      ),

                    // Bio preview
                    if (user.bio != null && user.bio!.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        user.bio!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color:
                              theme.colorScheme.onSurface.withValues(alpha: 0.7),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],

                    // Follower count
                    const SizedBox(height: 4),
                    Text(
                      '${_formatCount(user.followerCount)} followers',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color:
                            theme.colorScheme.onSurface.withValues(alpha: 0.5),
                      ),
                    ),

                    // Compatibility score
                    if (showCompatibility && user.compatibilityScore != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: CompatibilityBadge(
                          score: user.compatibilityScore!,
                          details: user.compatibilityDetails,
                        ),
                      ),
                  ],
                ),
              ),

              // Follow button
              const SizedBox(width: 8),
              _FollowButton(
                isFollowing: isFollowing,
                showFollowBack: showFollowBack && !isFollowing,
                onPressed: () => _handleFollowTap(ref, isFollowing),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleFollowTap(WidgetRef ref, bool currentlyFollowing) {
    ref.read(followNotifierProvider.notifier).toggleFollow(
          user.id,
          currentlyFollowing: currentlyFollowing,
        );
  }

  String _formatCount(int count) {
    if (count >= 1000000) {
      return '${(count / 1000000).toStringAsFixed(1)}M';
    } else if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}K';
    }
    return count.toString();
  }
}

class _UserAvatar extends StatelessWidget {
  const _UserAvatar({
    required this.avatarUrl,
    required this.name,
    this.hdType,
  });

  final String? avatarUrl;
  final String name;
  final String? hdType;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final borderColor = _getTypeColor(hdType);

    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: borderColor,
          width: 2,
        ),
      ),
      child: CircleAvatar(
        radius: 26,
        backgroundColor: theme.colorScheme.surfaceContainerHighest,
        backgroundImage: avatarUrl != null ? NetworkImage(avatarUrl!) : null,
        child: avatarUrl == null
            ? Text(
                name.isNotEmpty ? name[0].toUpperCase() : '?',
                style: theme.textTheme.titleLarge?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              )
            : null,
      ),
    );
  }

  Color _getTypeColor(String? type) {
    switch (type) {
      case 'Generator':
        return Colors.orange;
      case 'Manifesting Generator':
        return Colors.deepOrange;
      case 'Projector':
        return Colors.blue;
      case 'Manifestor':
        return Colors.red;
      case 'Reflector':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}

class _TypeChip extends StatelessWidget {
  const _TypeChip({required this.type});

  final String type;

  @override
  Widget build(BuildContext context) {
    final color = _getTypeColor(type);
    final shortType = _getShortType(type);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        shortType,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Color _getTypeColor(String type) {
    switch (type) {
      case 'Generator':
        return Colors.orange;
      case 'Manifesting Generator':
        return Colors.deepOrange;
      case 'Projector':
        return Colors.blue;
      case 'Manifestor':
        return Colors.red;
      case 'Reflector':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  String _getShortType(String type) {
    switch (type) {
      case 'Manifesting Generator':
        return 'MG';
      default:
        return type;
    }
  }
}

class _FollowButton extends StatelessWidget {
  const _FollowButton({
    required this.isFollowing,
    required this.showFollowBack,
    required this.onPressed,
  });

  final bool isFollowing;
  final bool showFollowBack;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (isFollowing) {
      return OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          minimumSize: const Size(0, 36),
        ),
        child: const Text('Following'),
      );
    }

    return FilledButton(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        minimumSize: const Size(0, 36),
        backgroundColor: showFollowBack
            ? theme.colorScheme.secondary
            : theme.colorScheme.primary,
      ),
      child: Text(showFollowBack ? 'Follow Back' : 'Follow'),
    );
  }
}
