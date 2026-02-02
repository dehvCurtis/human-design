import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/error_handler.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../domain/compatibility_circle_providers.dart';
import '../domain/models/compatibility_circle.dart';

class CircleDetailScreen extends ConsumerWidget {
  const CircleDetailScreen({super.key, required this.circleId});

  final String circleId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final circleAsync = ref.watch(circleProvider(circleId));

    return circleAsync.when(
      loading: () => Scaffold(
        appBar: AppBar(),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Scaffold(
        appBar: AppBar(),
        body: Center(child: Text(ErrorHandler.getUserMessage(e))),
      ),
      data: (circle) {
        if (circle == null) {
          return Scaffold(
            appBar: AppBar(),
            body: Center(child: Text(l10n.circles_notFound)),
          );
        }

        return DefaultTabController(
          length: 3,
          child: Scaffold(
            appBar: AppBar(
              title: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(circle.iconEmoji ?? '\u{2B50}'),
                  const SizedBox(width: 8),
                  Text(circle.name),
                ],
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.person_add),
                  onPressed: () => _showInviteDialog(context, ref, circle),
                  tooltip: l10n.circles_invite,
                ),
                PopupMenuButton<String>(
                  onSelected: (value) => _handleMenuAction(context, ref, value, circle),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          const Icon(Icons.edit),
                          const SizedBox(width: 8),
                          Text(l10n.common_edit),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete, color: Theme.of(context).colorScheme.error),
                          const SizedBox(width: 8),
                          Text(l10n.common_delete, style: TextStyle(color: Theme.of(context).colorScheme.error)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
              bottom: TabBar(
                tabs: [
                  Tab(text: l10n.circles_members),
                  Tab(text: l10n.circles_analysis),
                  Tab(text: l10n.circles_feed),
                ],
              ),
            ),
            body: TabBarView(
              children: [
                _MembersTab(circleId: circleId),
                _AnalysisTab(circleId: circleId),
                _FeedTab(circleId: circleId),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showInviteDialog(BuildContext context, WidgetRef ref, CompatibilityCircle circle) {
    final l10n = AppLocalizations.of(context)!;
    final emailController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.circles_inviteMember),
        content: TextField(
          controller: emailController,
          decoration: InputDecoration(
            labelText: l10n.auth_email,
            hintText: 'friend@example.com',
          ),
          keyboardType: TextInputType.emailAddress,
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () async {
              if (emailController.text.trim().isEmpty) return;

              final notifier = ref.read(compatibilityCircleNotifierProvider.notifier);
              final success = await notifier.inviteUser(circle.id, emailController.text.trim());

              if (context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(success
                        ? l10n.circles_invitationSent
                        : l10n.circles_invitationFailed),
                  ),
                );
              }
            },
            child: Text(l10n.circles_sendInvite),
          ),
        ],
      ),
    );
  }

  void _handleMenuAction(BuildContext context, WidgetRef ref, String action, CompatibilityCircle circle) {
    final l10n = AppLocalizations.of(context)!;

    switch (action) {
      case 'edit':
        // Show edit dialog
        break;
      case 'delete':
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(l10n.circles_deleteTitle),
            content: Text(l10n.circles_deleteConfirmation(circle.name)),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(l10n.cancel),
              ),
              FilledButton(
                onPressed: () async {
                  Navigator.pop(context);
                  final notifier = ref.read(compatibilityCircleNotifierProvider.notifier);
                  final success = await notifier.deleteCircle(circle.id);
                  if (context.mounted && success) {
                    Navigator.pop(context); // Go back to circles list
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(l10n.circles_deleted)),
                    );
                  }
                },
                style: FilledButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.error,
                ),
                child: Text(l10n.common_delete),
              ),
            ],
          ),
        );
        break;
    }
  }
}

class _MembersTab extends ConsumerWidget {
  const _MembersTab({required this.circleId});

  final String circleId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final membersAsync = ref.watch(circleMembersProvider(circleId));

    return membersAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text(ErrorHandler.getUserMessage(e))),
      data: (members) {
        if (members.isEmpty) {
          return Center(
            child: Text(l10n.circles_noMembers),
          );
        }

        return RefreshIndicator(
          onRefresh: () => ref.refresh(circleMembersProvider(circleId).future),
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: members.length,
            itemBuilder: (context, index) {
              final member = members[index];
              return _MemberCard(member: member, circleId: circleId);
            },
          ),
        );
      },
    );
  }
}

class _MemberCard extends StatelessWidget {
  const _MemberCard({required this.member, required this.circleId});

  final CircleMember member;
  final String circleId;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: member.userAvatarUrl != null
              ? NetworkImage(member.userAvatarUrl!)
              : null,
          child: member.userAvatarUrl == null
              ? Text(member.userName[0].toUpperCase())
              : null,
        ),
        title: Row(
          children: [
            Text(member.userName),
            if (member.role != CircleRole.member) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  member.role.displayName,
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ),
            ],
          ],
        ),
        subtitle: member.hdType != null
            ? Row(
                children: [
                  Text(member.hdType!),
                  if (member.hdProfile != null) ...[
                    const SizedBox(width: 8),
                    const Text('\u{2022}'),
                    const SizedBox(width: 8),
                    Text(member.hdProfile!),
                  ],
                ],
              )
            : null,
        trailing: member.hdType != null
            ? Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getTypeColor(member.hdType!).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  member.hdType!,
                  style: TextStyle(
                    color: _getTypeColor(member.hdType!),
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              )
            : null,
      ),
    );
  }

  Color _getTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'manifestor':
        return Colors.red;
      case 'generator':
        return Colors.orange;
      case 'manifesting generator':
        return Colors.amber;
      case 'projector':
        return Colors.blue;
      case 'reflector':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }
}

class _AnalysisTab extends ConsumerWidget {
  const _AnalysisTab({required this.circleId});

  final String circleId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final analysisAsync = ref.watch(circleAnalysisProvider(circleId));
    final membersAsync = ref.watch(circleMembersProvider(circleId));

    return analysisAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text(ErrorHandler.getUserMessage(e))),
      data: (analysis) {
        if (analysis == null) {
          return membersAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text(ErrorHandler.getUserMessage(e))),
            data: (members) {
              final canAnalyze = members.length >= 2;

              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.analytics_outlined,
                        size: 64,
                        color: Theme.of(context).colorScheme.outline,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        l10n.circles_noAnalysis,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        canAnalyze
                            ? l10n.circles_runAnalysis
                            : l10n.circles_needMoreMembers,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.outline,
                        ),
                      ),
                      if (canAnalyze) ...[
                        const SizedBox(height: 24),
                        FilledButton.icon(
                          onPressed: () async {
                            final notifier = ref.read(compatibilityCircleNotifierProvider.notifier);
                            await notifier.requestAnalysis(circleId);
                          },
                          icon: const Icon(Icons.play_arrow),
                          label: Text(l10n.circles_analyzeCompatibility),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            },
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Harmony Score
              _HarmonyScoreCard(score: analysis.overallHarmonyScore),
              const SizedBox(height: 16),

              // Type Distribution
              _TypeDistributionCard(distribution: analysis.typeDistribution),
              const SizedBox(height: 16),

              // Connections
              if (analysis.electromagneticConnections.isNotEmpty) ...[
                _ConnectionsSection(
                  title: l10n.circles_electromagneticConnections,
                  description: l10n.circles_electromagneticDesc,
                  connections: analysis.electromagneticConnections,
                  color: Colors.pink,
                ),
                const SizedBox(height: 16),
              ],

              if (analysis.companionshipConnections.isNotEmpty) ...[
                _ConnectionsSection(
                  title: l10n.circles_companionshipConnections,
                  description: l10n.circles_companionshipDesc,
                  connections: analysis.companionshipConnections,
                  color: Colors.blue,
                ),
                const SizedBox(height: 16),
              ],

              // Group Strengths
              _InsightsCard(
                title: l10n.circles_groupStrengths,
                items: analysis.groupStrengths,
                icon: Icons.star,
                color: Colors.green,
              ),
              const SizedBox(height: 16),

              // Areas for Growth
              _InsightsCard(
                title: l10n.circles_areasForGrowth,
                items: analysis.areasForGrowth,
                icon: Icons.trending_up,
                color: Colors.orange,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _HarmonyScoreCard extends StatelessWidget {
  const _HarmonyScoreCard({required this.score});

  final double score;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final color = score >= 0.7
        ? Colors.green
        : score >= 0.5
            ? Colors.orange
            : Colors.red;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              l10n.circles_harmonyScore,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 120,
                  height: 120,
                  child: CircularProgressIndicator(
                    value: score,
                    strokeWidth: 12,
                    backgroundColor: Colors.grey.shade200,
                    valueColor: AlwaysStoppedAnimation(color),
                  ),
                ),
                Column(
                  children: [
                    Text(
                      '${(score * 100).toInt()}%',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _TypeDistributionCard extends StatelessWidget {
  const _TypeDistributionCard({required this.distribution});

  final Map<String, int> distribution;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.circles_typeDistribution,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...distribution.entries.map((entry) {
              final color = _getTypeColor(entry.key);
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(entry.key),
                    const Spacer(),
                    Text(
                      entry.value.toString(),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Color _getTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'manifestor':
        return Colors.red;
      case 'generator':
        return Colors.orange;
      case 'manifesting generator':
        return Colors.amber;
      case 'projector':
        return Colors.blue;
      case 'reflector':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }
}

class _ConnectionsSection extends StatelessWidget {
  const _ConnectionsSection({
    required this.title,
    required this.description,
    required this.connections,
    required this.color,
  });

  final String title;
  final String description;
  final List<CircleConnection> connections;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.link, color: color, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        description,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.outline,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            ...connections.map((conn) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Text(conn.member1Name),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Icon(Icons.compare_arrows, size: 16, color: color),
                  ),
                  Text(conn.member2Name),
                  const Spacer(),
                  Text(
                    conn.channel,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.outline,
                    ),
                  ),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }
}

class _InsightsCard extends StatelessWidget {
  const _InsightsCard({
    required this.title,
    required this.items,
    required this.icon,
    required this.color,
  });

  final String title;
  final List<String> items;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 20),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...items.map((item) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    margin: const EdgeInsets.only(top: 6),
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(child: Text(item)),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }
}

class _FeedTab extends ConsumerStatefulWidget {
  const _FeedTab({required this.circleId});

  final String circleId;

  @override
  ConsumerState<_FeedTab> createState() => _FeedTabState();
}

class _FeedTabState extends ConsumerState<_FeedTab> {
  final _postController = TextEditingController();

  @override
  void dispose() {
    _postController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final postsAsync = ref.watch(circlePostsProvider(widget.circleId));

    return Column(
      children: [
        // Post composer
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            border: Border(
              bottom: BorderSide(
                color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
              ),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _postController,
                  decoration: InputDecoration(
                    hintText: l10n.circles_writePost,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                  ),
                  maxLines: null,
                ),
              ),
              const SizedBox(width: 8),
              IconButton.filled(
                onPressed: _submitPost,
                icon: const Icon(Icons.send),
              ),
            ],
          ),
        ),

        // Posts list
        Expanded(
          child: postsAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text(ErrorHandler.getUserMessage(e))),
            data: (posts) {
              if (posts.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.forum_outlined,
                        size: 64,
                        color: Theme.of(context).colorScheme.outline,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        l10n.circles_noPosts,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        l10n.circles_beFirstToPost,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.outline,
                        ),
                      ),
                    ],
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: () => ref.refresh(circlePostsProvider(widget.circleId).future),
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    final post = posts[index];
                    return _PostCard(post: post);
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void _submitPost() async {
    if (_postController.text.trim().isEmpty) return;

    final notifier = ref.read(compatibilityCircleNotifierProvider.notifier);
    await notifier.createPost(
      circleId: widget.circleId,
      content: _postController.text.trim(),
    );

    _postController.clear();
  }
}

class _PostCard extends StatelessWidget {
  const _PostCard({required this.post});

  final CirclePost post;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: post.userAvatarUrl != null
                      ? NetworkImage(post.userAvatarUrl!)
                      : null,
                  child: post.userAvatarUrl == null
                      ? Text(post.userName[0].toUpperCase())
                      : null,
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post.userName,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      _formatTime(post.createdAt),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.outline,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(post.content),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);

    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${time.day}/${time.month}/${time.year}';
  }
}
