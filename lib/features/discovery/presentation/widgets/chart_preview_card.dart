import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../l10n/generated/app_localizations.dart';
import '../../../chart/presentation/widgets/bodygraph/bodygraph_widget.dart';
import '../../domain/discovery_providers.dart';

/// A card showing a mini bodygraph preview for discovery/popular charts
class ChartPreviewCard extends ConsumerWidget {
  const ChartPreviewCard({
    super.key,
    required this.userId,
    required this.name,
    this.avatarUrl,
    this.hdType,
    this.hdProfile,
    this.followerCount = 0,
    this.isFollowing = false,
    this.onTap,
  });

  final String userId;
  final String name;
  final String? avatarUrl;
  final String? hdType;
  final String? hdProfile;
  final int followerCount;
  final bool isFollowing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final chartAsync = ref.watch(userPublicChartProvider(userId));

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            // Mini bodygraph preview
            Container(
              width: 120,
              height: 160,
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              child: chartAsync.when(
                data: (chart) {
                  if (chart == null) {
                    return Center(
                      child: Icon(
                        Icons.auto_graph_outlined,
                        size: 40,
                        color: Theme.of(context).colorScheme.outline,
                      ),
                    );
                  }
                  return Padding(
                    padding: const EdgeInsets.all(8),
                    child: BodygraphWidget(
                      chart: chart,
                      interactive: false,
                      showGateNumbers: false,
                    ),
                  );
                },
                loading: () => const Center(
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
                error: (_, _) => Center(
                  child: Icon(
                    Icons.auto_graph_outlined,
                    size: 40,
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ),
              ),
            ),

            // User info
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // User header (avatar + name)
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 18,
                          backgroundImage: avatarUrl != null
                              ? NetworkImage(avatarUrl!)
                              : null,
                          child: avatarUrl == null
                              ? Text(
                                  name.isNotEmpty ? name[0].toUpperCase() : '?',
                                  style: const TextStyle(fontSize: 14),
                                )
                              : null,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                name,
                                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              if (followerCount > 0)
                                Text(
                                  '$followerCount ${l10n.discovery_followers}',
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Theme.of(context).colorScheme.outline,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // HD Type badge
                    if (hdType != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          hdType!,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.onPrimaryContainer,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    const SizedBox(height: 4),

                    // Profile
                    if (hdProfile != null)
                      Text(
                        'Profile $hdProfile',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.outline,
                        ),
                      ),

                    const Spacer(),

                    // Follow status
                    if (isFollowing)
                      Row(
                        children: [
                          Icon(
                            Icons.check_circle,
                            size: 14,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            l10n.discovery_following,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),

            // Arrow indicator
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Icon(
                Icons.chevron_right,
                color: Theme.of(context).colorScheme.outline,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
