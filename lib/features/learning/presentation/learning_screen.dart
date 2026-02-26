import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../domain/learning_providers.dart';
import '../domain/models/learning.dart';

class LearningScreen extends ConsumerStatefulWidget {
  const LearningScreen({super.key});

  @override
  ConsumerState<LearningScreen> createState() => _LearningScreenState();
}

class _LearningScreenState extends ConsumerState<LearningScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.learning_learn),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go(AppRoutes.home);
            }
          },
        ),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabAlignment: TabAlignment.center,
          tabs: [
            Tab(text: l10n.learning_all),
            Tab(text: l10n.learning_types),
            Tab(text: l10n.learning_gates),
            Tab(text: l10n.learning_centers),
          ],
        ),
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: l10n.learning_searchContent,
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: theme.colorScheme.surfaceContainerHighest,
              ),
              onChanged: (value) {
                final currentFilter = ref.read(contentFilterProvider);
                ref.read(contentFilterProvider.notifier).state =
                    currentFilter.copyWith(searchQuery: value);
              },
            ),
          ),

          // Quick actions
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: _QuickActionCard(
                    icon: Icons.school,
                    label: l10n.learning_mentorship,
                    onTap: () => context.push(AppRoutes.mentorship),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _QuickActionCard(
                    icon: Icons.live_tv,
                    label: l10n.learning_liveSessions,
                    onTap: () => context.push(AppRoutes.sessions),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Content tabs
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _ContentTab(filter: const ContentFilter()),
                _ContentTab(filter: const ContentFilter(category: ContentCategory.type)),
                _ContentTab(filter: const ContentFilter(category: ContentCategory.gate)),
                _ContentTab(filter: const ContentFilter(category: ContentCategory.center)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  const _QuickActionCard({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(icon, color: theme.colorScheme.primary),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: theme.textTheme.titleSmall,
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: theme.colorScheme.outline,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ContentTab extends ConsumerWidget {
  const _ContentTab({required this.filter});

  final ContentFilter filter;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final searchQuery = ref.watch(contentFilterProvider).searchQuery;
    final effectiveFilter = filter.copyWith(searchQuery: searchQuery);
    final contentAsync = ref.watch(contentLibraryProvider(effectiveFilter));

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(contentLibraryProvider(effectiveFilter));
      },
      child: contentAsync.when(
        data: (content) {
          if (content.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.library_books_outlined,
                    size: 64,
                    color: theme.colorScheme.outline,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No content found',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.outline,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: content.length,
            itemBuilder: (context, index) {
              return _ContentCard(
                content: content[index],
                onTap: () {
                  context.push('${AppRoutes.learning}/${content[index].id}');
                },
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error_outline, size: 48, color: theme.colorScheme.error),
              const SizedBox(height: 16),
              Text(AppLocalizations.of(context)!.learning_errorLoading),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => ref.invalidate(contentLibraryProvider(effectiveFilter)),
                child: Text(AppLocalizations.of(context)!.common_retry),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ContentCard extends StatelessWidget {
  const _ContentCard({
    required this.content,
    required this.onTap,
  });

  final LearningContent content;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasProgress = content.userProgress != null;
    final progress = content.userProgress?.progressPercent ?? 0;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Type icon
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      _getContentTypeIcon(content.contentType),
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Content info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                content.title,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (content.isPremium)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.tertiaryContainer,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  'PRO',
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    color: theme.colorScheme.tertiary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 4),

                        // Meta info
                        Row(
                          children: [
                            _CategoryChip(category: content.category),
                            if (content.gateNumber != null) ...[
                              const SizedBox(width: 8),
                              Text(
                                'Gate ${content.gateNumber}',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.outline,
                                ),
                              ),
                            ],
                            if (content.estimatedReadTime != null) ...[
                              const SizedBox(width: 8),
                              Icon(
                                Icons.schedule,
                                size: 14,
                                color: theme.colorScheme.outline,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${content.estimatedReadTime} min',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.outline,
                                ),
                              ),
                            ],
                          ],
                        ),

                        const SizedBox(height: 8),

                        // Stats
                        Row(
                          children: [
                            Icon(
                              Icons.visibility,
                              size: 14,
                              color: theme.colorScheme.outline,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${content.viewCount}',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.outline,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Icon(
                              Icons.thumb_up_outlined,
                              size: 14,
                              color: theme.colorScheme.outline,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${content.likeCount}',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.outline,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Progress bar
            if (hasProgress) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(2),
                        child: LinearProgressIndicator(
                          value: progress / 100,
                          minHeight: 4,
                          backgroundColor: theme.colorScheme.surfaceContainerHighest,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '$progress%',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
            ],
          ],
        ),
      ),
    );
  }

  IconData _getContentTypeIcon(ContentType type) {
    switch (type) {
      case ContentType.article:
        return Icons.article;
      case ContentType.guide:
        return Icons.menu_book;
      case ContentType.quiz:
        return Icons.quiz;
      case ContentType.video:
        return Icons.play_circle;
      case ContentType.infographic:
        return Icons.image;
    }
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({required this.category});

  final ContentCategory category;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: theme.colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        _getCategoryName(category),
        style: theme.textTheme.labelSmall?.copyWith(
          color: theme.colorScheme.onSecondaryContainer,
        ),
      ),
    );
  }

  String _getCategoryName(ContentCategory category) {
    switch (category) {
      case ContentCategory.type:
        return 'Type';
      case ContentCategory.authority:
        return 'Authority';
      case ContentCategory.profile:
        return 'Profile';
      case ContentCategory.gate:
        return 'Gate';
      case ContentCategory.channel:
        return 'Channel';
      case ContentCategory.center:
        return 'Center';
      case ContentCategory.transit:
        return 'Transit';
      case ContentCategory.general:
        return 'General';
    }
  }
}
