import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../domain/discovery_providers.dart';
import '../domain/models/user_discovery.dart';
import 'widgets/user_card.dart';
import 'widgets/discovery_filter_sheet.dart';
import 'widgets/type_filter_chips.dart';

class DiscoveryScreen extends ConsumerStatefulWidget {
  const DiscoveryScreen({super.key});

  @override
  ConsumerState<DiscoveryScreen> createState() => _DiscoveryScreenState();
}

class _DiscoveryScreenState extends ConsumerState<DiscoveryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
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

    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Search users...',
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: theme.hintColor),
                ),
                style: theme.textTheme.bodyLarge,
                onChanged: (value) {
                  // Trigger search
                  setState(() {});
                },
              )
            : const Text('Discover'),
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) {
                  _searchController.clear();
                }
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.star_outlined),
            tooltip: 'Popular Charts',
            onPressed: () => context.push(AppRoutes.popularCharts),
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilterSheet(context),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Discover'),
            Tab(text: 'Following'),
            Tab(text: 'Followers'),
          ],
        ),
      ),
      body: _isSearching && _searchController.text.isNotEmpty
          ? _SearchResultsView(query: _searchController.text)
          : TabBarView(
              controller: _tabController,
              children: const [
                _DiscoverTab(),
                _FollowingTab(),
                _FollowersTab(),
              ],
            ),
    );
  }

  void _showFilterSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => const DiscoveryFilterSheet(),
    );
  }
}

class _DiscoverTab extends ConsumerWidget {
  const _DiscoverTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(discoveryFilterProvider);
    final discoveryAsync = ref.watch(discoveredUsersProvider);

    return Column(
      children: [
        // Filter chips
        if (filter.hasFilters)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TypeFilterChips(
              filter: filter,
              onFilterChanged: (newFilter) {
                ref.read(discoveryFilterProvider.notifier).state = newFilter;
              },
            ),
          ),

        // User list
        Expanded(
          child: discoveryAsync.when(
            data: (result) {
              if (result.users.isEmpty) {
                return const _EmptyState(
                  icon: Icons.people_outline,
                  title: 'No users found',
                  subtitle: 'Try adjusting your filters',
                );
              }

              return RefreshIndicator(
                onRefresh: () async {
                  ref.invalidate(discoveredUsersProvider);
                },
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: result.users.length,
                  itemBuilder: (context, index) {
                    return UserCard(
                      user: result.users[index],
                      onTap: () => _navigateToProfile(context, result.users[index]),
                    );
                  },
                ),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => _ErrorState(
              error: error.toString(),
              onRetry: () => ref.invalidate(discoveredUsersProvider),
            ),
          ),
        ),
      ],
    );
  }

  void _navigateToProfile(BuildContext context, DiscoveredUser user) {
    context.pushNamed('userProfile', pathParameters: {'id': user.id});
  }
}

class _FollowingTab extends ConsumerWidget {
  const _FollowingTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final followingAsync = ref.watch(followingListProvider);

    return followingAsync.when(
      data: (users) {
        if (users.isEmpty) {
          return const _EmptyState(
            icon: Icons.person_add_outlined,
            title: 'Not following anyone',
            subtitle: 'Discover people to follow',
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(followingListProvider);
          },
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: users.length,
            itemBuilder: (context, index) {
              return UserCard(
                user: users[index],
                onTap: () => context.pushNamed('userProfile', pathParameters: {'id': users[index].id}),
              );
            },
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => _ErrorState(
        error: error.toString(),
        onRetry: () => ref.invalidate(followingListProvider),
      ),
    );
  }
}

class _FollowersTab extends ConsumerWidget {
  const _FollowersTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final followersAsync = ref.watch(followersListProvider);

    return followersAsync.when(
      data: (users) {
        if (users.isEmpty) {
          return const _EmptyState(
            icon: Icons.people_outline,
            title: 'No followers yet',
            subtitle: 'Share your insights to gain followers',
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(followersListProvider);
          },
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: users.length,
            itemBuilder: (context, index) {
              return UserCard(
                user: users[index],
                showFollowBack: !users[index].isFollowing,
                onTap: () => context.pushNamed('userProfile', pathParameters: {'id': users[index].id}),
              );
            },
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => _ErrorState(
        error: error.toString(),
        onRetry: () => ref.invalidate(followersListProvider),
      ),
    );
  }
}

class _SearchResultsView extends ConsumerWidget {
  const _SearchResultsView({required this.query});

  final String query;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchAsync = ref.watch(userSearchProvider(query));

    return searchAsync.when(
      data: (users) {
        if (users.isEmpty) {
          return _EmptyState(
            icon: Icons.search_off,
            title: 'No results for "$query"',
            subtitle: 'Try a different search term',
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: users.length,
          itemBuilder: (context, index) {
            return UserCard(
              user: users[index],
              onTap: () => context.pushNamed('userProfile', pathParameters: {'id': users[index].id}),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => _ErrorState(
        error: error.toString(),
        onRetry: () => ref.invalidate(userSearchProvider(query)),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

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
              icon,
              size: 64,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: theme.textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
              textAlign: TextAlign.center,
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
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: theme.colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              'Something went wrong',
              style: theme.textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              error,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
