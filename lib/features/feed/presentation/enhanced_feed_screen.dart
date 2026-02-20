import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/utils/error_handler.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../hashtags/domain/hashtag_providers.dart';
import '../../hashtags/domain/models/hashtag.dart';
import '../domain/feed_providers.dart';
import 'widgets/create_post_sheet.dart';
import 'widgets/post_card.dart';

/// Enhanced Feed Screen with trending hashtags and discovery features
class EnhancedFeedScreen extends ConsumerStatefulWidget {
  const EnhancedFeedScreen({super.key});

  @override
  ConsumerState<EnhancedFeedScreen> createState() => _EnhancedFeedScreenState();
}

class _EnhancedFeedScreenState extends ConsumerState<EnhancedFeedScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.nav_social),
        actions: [
          IconButton(
            icon: const Icon(Icons.tag),
            tooltip: l10n.hashtags_explore,
            onPressed: () => context.push('/hashtags'),
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => _showSearchSheet(context),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabAlignment: TabAlignment.center,
          tabs: [
            Tab(text: l10n.feed_forYou),
            Tab(text: l10n.feed_trending),
            Tab(text: l10n.feed_hdTopics),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _ForYouTab(),
          _TrendingTab(),
          _HdTopicsTab(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreatePostSheet(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showCreatePostSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) => const CreatePostSheet(),
    );
  }

  void _showSearchSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) => const _SearchSheet(),
    );
  }
}

class _ForYouTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final feedAsync = ref.watch(feedProvider);
    final trendingAsync = ref.watch(trendingHashtagsProvider);

    return feedAsync.when(
      data: (posts) {
        if (posts.isEmpty) {
          return _EmptyFeedState();
        }

        return RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(feedProvider);
            ref.invalidate(trendingHashtagsProvider);
          },
          child: CustomScrollView(
            slivers: [
              // Trending hashtags bar
              SliverToBoxAdapter(
                child: trendingAsync.when(
                  data: (trending) => trending.isNotEmpty
                      ? _TrendingHashtagsBar(trending: trending)
                      : const SizedBox.shrink(),
                  loading: () => const SizedBox.shrink(),
                  error: (_, _) => const SizedBox.shrink(),
                ),
              ),

              // Posts
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final post = posts[index];
                    return PostCard(
                      post: post,
                      onTap: () => context.push('/feed/post/${post.id}'),
                      onReaction: (type) {
                        ref.read(feedNotifierProvider.notifier).reactToPost(post.id, type);
                      },
                      onComment: () => context.push('/feed/post/${post.id}'),
                      onShare: () {},
                      onUserTap: () {},
                      onHashtagTap: (hashtag) => context.push('/hashtag/$hashtag'),
                    );
                  },
                  childCount: posts.length,
                ),
              ),
            ],
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => _ErrorState(
        error: error.toString(),
        onRetry: () => ref.invalidate(feedProvider),
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
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.trending_up, size: 64, color: Colors.grey),
                const SizedBox(height: 16),
                Text(l10n.hashtags_noTrending),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () async => ref.invalidate(trendingHashtagsProvider),
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: trending.length,
            itemBuilder: (context, index) {
              final item = trending[index];
              return _TrendingHashtagCard(
                trending: item,
                rank: index + 1,
                onTap: () => context.push('/hashtag/${item.hashtag.name}'),
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

class _HdTopicsTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    // Pre-defined HD topic categories
    final hdTopics = [
      _HdTopicSection(
        title: l10n.quiz_category_types,
        icon: Icons.person_outline,
        color: Colors.blue,
        topics: ['generator', 'projector', 'manifestor', 'reflector', 'manifestinggenerator'],
      ),
      _HdTopicSection(
        title: l10n.quiz_category_authorities,
        icon: Icons.favorite_outline,
        color: Colors.green,
        topics: ['emotionalauthority', 'sacralauthority', 'splenicauthority', 'egoauthority'],
      ),
      _HdTopicSection(
        title: l10n.quiz_category_centers,
        icon: Icons.blur_circular,
        color: Colors.purple,
        topics: ['sacral', 'throat', 'gcenter', 'ajna', 'head', 'spleen', 'solarplexus', 'root', 'heart'],
      ),
      _HdTopicSection(
        title: l10n.quiz_category_gates,
        icon: Icons.label_outline,
        color: Colors.amber,
        topics: ['gate1', 'gate2', 'gate41', 'gate64', 'gate13', 'gate25', 'gate46'],
      ),
      _HdTopicSection(
        title: l10n.quiz_category_general,
        icon: Icons.auto_graph,
        color: Colors.indigo,
        topics: ['humandesign', 'bodygraph', 'transits', 'strategy', 'deconditioning'],
      ),
    ];

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: hdTopics.length,
      itemBuilder: (context, index) {
        final section = hdTopics[index];
        return _TopicSectionCard(section: section);
      },
    );
  }
}

class _TrendingHashtagsBar extends StatelessWidget {
  const _TrendingHashtagsBar({required this.trending});

  final List<TrendingHashtag> trending;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        border: Border(
          bottom: BorderSide(
            color: theme.colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Icon(
                  Icons.trending_up,
                  size: 16,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  l10n.hashtags_trending,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 36,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: trending.take(5).length,
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final item = trending[index];
                return ActionChip(
                  label: Text('#${item.hashtag.name}'),
                  avatar: Text(
                    '${index + 1}',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  onPressed: () => context.push('/hashtag/${item.hashtag.name}'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _TrendingHashtagCard extends StatelessWidget {
  const _TrendingHashtagCard({
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

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: rank <= 3
              ? _getRankColor(rank).withValues(alpha: 0.2)
              : theme.colorScheme.surfaceContainerHigh,
          child: Text(
            '$rank',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: rank <= 3 ? _getRankColor(rank) : theme.colorScheme.outline,
            ),
          ),
        ),
        title: Text(
          '#${trending.hashtag.name}',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              l10n.hashtag_postCount(trending.hashtag.postCount),
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.outline,
              ),
            ),
            if (trending.recentPostCount > 0) ...[
              const SizedBox(height: 2),
              Text(
                l10n.hashtag_recentPosts(trending.recentPostCount),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ],
        ),
        trailing: trending.percentChange != null && trending.percentChange! > 0
            ? Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.trending_up, size: 14, color: Colors.green),
                    const SizedBox(width: 4),
                    Text(
                      '+${trending.percentChange!.toStringAsFixed(0)}%',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              )
            : const Icon(Icons.chevron_right),
      ),
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

class _HdTopicSection {
  const _HdTopicSection({
    required this.title,
    required this.icon,
    required this.color,
    required this.topics,
  });

  final String title;
  final IconData icon;
  final Color color;
  final List<String> topics;
}

class _TopicSectionCard extends StatelessWidget {
  const _TopicSectionCard({required this.section});

  final _HdTopicSection section;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(section.icon, color: section.color, size: 20),
                const SizedBox(width: 8),
                Text(
                  section.title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: section.color,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: section.topics.map((topic) {
                return ActionChip(
                  label: Text('#$topic'),
                  backgroundColor: section.color.withValues(alpha: 0.1),
                  labelStyle: TextStyle(
                    color: section.color,
                    fontWeight: FontWeight.w500,
                  ),
                  onPressed: () => context.push('/hashtag/$topic'),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchSheet extends ConsumerStatefulWidget {
  const _SearchSheet();

  @override
  ConsumerState<_SearchSheet> createState() => _SearchSheetState();
}

class _SearchSheetState extends ConsumerState<_SearchSheet> {
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final searchResults = ref.watch(hashtagSearchProvider(_query));

    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Handle
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: theme.colorScheme.outline.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Search field
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  controller: _searchController,
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: l10n.common_search,
                    prefixIcon: const Icon(Icons.search),
                    border: const OutlineInputBorder(),
                    suffixIcon: _query.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              setState(() => _query = '');
                            },
                          )
                        : null,
                  ),
                  onChanged: (value) {
                    setState(() => _query = value);
                  },
                ),
              ),

              // Results
              Expanded(
                child: _query.isEmpty
                    ? _RecentSearches()
                    : searchResults.when(
                        data: (hashtags) {
                          if (hashtags.isEmpty) {
                            return Center(
                              child: Text(
                                'No hashtags found for "$_query"',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.colorScheme.outline,
                                ),
                              ),
                            );
                          }

                          return ListView.builder(
                            controller: scrollController,
                            itemCount: hashtags.length,
                            itemBuilder: (context, index) {
                              final hashtag = hashtags[index];
                              return ListTile(
                                leading: const Icon(Icons.tag),
                                title: Text('#${hashtag.name}'),
                                subtitle: Text(
                                  '${hashtag.postCount} posts',
                                  style: theme.textTheme.bodySmall,
                                ),
                                onTap: () {
                                  Navigator.pop(context);
                                  context.push('/hashtag/${hashtag.name}');
                                },
                              );
                            },
                          );
                        },
                        loading: () => const Center(child: CircularProgressIndicator()),
                        error: (e, _) => Center(child: Text(ErrorHandler.getUserMessage(e))),
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _RecentSearches extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    // Popular HD hashtags for quick access
    final popularHdTags = [
      'generator',
      'projector',
      'manifestor',
      'reflector',
      'humandesign',
      'bodygraph',
      'sacral',
      'transits',
    ];

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      children: [
        Text(
          l10n.hashtags_popular,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: popularHdTags.map((tag) {
            return ActionChip(
              label: Text('#$tag'),
              onPressed: () {
                Navigator.pop(context);
                context.push('/hashtag/$tag');
              },
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _EmptyFeedState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.dynamic_feed_outlined,
              size: 64,
              color: theme.colorScheme.outline,
            ),
            const SizedBox(height: 16),
            Text(
              'No posts yet',
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.outline,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Be the first to share something!',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.outline,
              ),
            ),
          ],
        ),
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
