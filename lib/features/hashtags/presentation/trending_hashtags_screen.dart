import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/utils/error_handler.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../domain/hashtag_providers.dart';
import '../domain/models/hashtag.dart';

/// Screen showing trending hashtags
class TrendingHashtagsScreen extends ConsumerWidget {
  const TrendingHashtagsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.hashtags_explore),
          bottom: TabBar(
            isScrollable: true,
            tabAlignment: TabAlignment.center,
            tabs: [
              Tab(text: l10n.hashtags_trending),
              Tab(text: l10n.hashtags_popular),
              Tab(text: l10n.hashtags_hdTopics),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _TrendingTab(),
            _PopularTab(),
            _HdTopicsTab(),
          ],
        ),
      ),
    );
  }
}

class _TrendingTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final trendingAsync = ref.watch(trendingHashtagsProvider);

    return trendingAsync.when(
      data: (trending) {
        if (trending.isEmpty) {
          return _EmptyState(message: l10n.hashtags_noTrending);
        }

        return RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(trendingHashtagsProvider);
          },
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: trending.length,
            itemBuilder: (context, index) {
              final item = trending[index];
              return _TrendingHashtagTile(
                trending: item,
                rank: index + 1,
                onTap: () {
                  context.push('/hashtag/${item.hashtag.name}');
                },
              );
            },
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => _ErrorState(
        error: error.toString(),
        onRetry: () => ref.invalidate(trendingHashtagsProvider),
      ),
    );
  }
}

class _PopularTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final popularAsync = ref.watch(popularHashtagsProvider);

    return popularAsync.when(
      data: (hashtags) {
        if (hashtags.isEmpty) {
          return _EmptyState(message: l10n.hashtags_noPopular);
        }

        return RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(popularHashtagsProvider);
          },
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: hashtags.length,
            itemBuilder: (context, index) {
              final hashtag = hashtags[index];
              return _HashtagTile(
                hashtag: hashtag,
                onTap: () {
                  context.push('/hashtag/${hashtag.name}');
                },
              );
            },
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => _ErrorState(
        error: error.toString(),
        onRetry: () => ref.invalidate(popularHashtagsProvider),
      ),
    );
  }
}

class _HdTopicsTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final hdHashtagsAsync = ref.watch(hdHashtagsProvider);

    return hdHashtagsAsync.when(
      data: (hashtags) {
        if (hashtags.isEmpty) {
          return _EmptyState(message: l10n.hashtags_noHdTopics);
        }

        // Group by category
        final grouped = <HashtagCategory, List<Hashtag>>{};
        for (final hashtag in hashtags) {
          final category = hashtag.hdCategory;
          if (category != null) {
            grouped.putIfAbsent(category, () => []).add(hashtag);
          }
        }

        return RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(hdHashtagsProvider);
          },
          child: ListView(
            padding: const EdgeInsets.symmetric(vertical: 8),
            children: [
              for (final category in HashtagCategory.values)
                if (grouped[category]?.isNotEmpty == true) ...[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                    child: Text(
                      category.displayName,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: _getCategoryColor(category),
                      ),
                    ),
                  ),
                  ...grouped[category]!.map((hashtag) => _HashtagTile(
                    hashtag: hashtag,
                    onTap: () {
                      context.push('/hashtag/${hashtag.name}');
                    },
                  )),
                ],
            ],
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => _ErrorState(
        error: error.toString(),
        onRetry: () => ref.invalidate(hdHashtagsProvider),
      ),
    );
  }
}

class _TrendingHashtagTile extends StatelessWidget {
  const _TrendingHashtagTile({
    required this.trending,
    required this.rank,
    required this.onTap,
  });

  final TrendingHashtag trending;
  final int rank;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return ListTile(
      onTap: onTap,
      leading: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: rank <= 3
              ? _getRankColor(rank).withValues(alpha: 0.1)
              : theme.colorScheme.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            '$rank',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: rank <= 3 ? _getRankColor(rank) : theme.colorScheme.outline,
            ),
          ),
        ),
      ),
      title: Text(
        '#${trending.hashtag.name}',
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        l10n.hashtag_recentPosts(trending.recentPostCount),
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.outline,
        ),
      ),
      trailing: trending.percentChange != null
          ? _TrendIndicator(percentChange: trending.percentChange!)
          : null,
    );
  }

  Color _getRankColor(int rank) {
    switch (rank) {
      case 1:
        return Colors.amber;
      case 2:
        return Colors.grey;
      case 3:
        return Colors.brown;
      default:
        return Colors.grey;
    }
  }
}

class _TrendIndicator extends StatelessWidget {
  const _TrendIndicator({required this.percentChange});

  final double percentChange;

  @override
  Widget build(BuildContext context) {
    final isUp = percentChange > 0;
    final color = isUp ? Colors.green : Colors.red;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          isUp ? Icons.trending_up : Icons.trending_down,
          size: 16,
          color: color,
        ),
        const SizedBox(width: 4),
        Text(
          '${percentChange.abs().toStringAsFixed(0)}%',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: color,
          ),
        ),
      ],
    );
  }
}

class _HashtagTile extends StatelessWidget {
  const _HashtagTile({
    required this.hashtag,
    required this.onTap,
  });

  final Hashtag hashtag;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final category = hashtag.hdCategory;

    return ListTile(
      onTap: onTap,
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: _getCategoryColor(category).withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            '#',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: _getCategoryColor(category),
            ),
          ),
        ),
      ),
      title: Text(
        '#${hashtag.name}',
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        l10n.hashtag_postCount(hashtag.postCount),
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.outline,
        ),
      ),
      trailing: category != null
          ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: _getCategoryColor(category).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                category.displayName,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: _getCategoryColor(category),
                ),
              ),
            )
          : null,
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.tag,
            size: 64,
            color: theme.colorScheme.outline,
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.outline,
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({
    required this.error,
    required this.onRetry,
  });

  final String error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline, size: 48, color: Colors.red),
          const SizedBox(height: 16),
          Text(ErrorHandler.getUserMessage(error)),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: onRetry,
            child: Text(l10n.common_retry),
          ),
        ],
      ),
    );
  }
}

Color _getCategoryColor(HashtagCategory? category) {
  switch (category) {
    case HashtagCategory.gate:
      return Colors.amber;
    case HashtagCategory.channel:
      return Colors.purple;
    case HashtagCategory.type:
      return Colors.blue;
    case HashtagCategory.authority:
      return Colors.green;
    case HashtagCategory.profile:
      return Colors.orange;
    case HashtagCategory.center:
      return Colors.teal;
    case null:
      return Colors.grey;
  }
}
