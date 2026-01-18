import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../domain/learning_providers.dart';
import '../domain/models/learning.dart';

class MentorshipScreen extends ConsumerWidget {
  const MentorshipScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final mentorsAsync = ref.watch(mentorsProvider);
    final myProfileAsync = ref.watch(myMentorshipProfileProvider);
    final requestsAsync = ref.watch(pendingMentorshipRequestsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mentorship'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(mentorsProvider);
          ref.invalidate(myMentorshipProfileProvider);
          ref.invalidate(pendingMentorshipRequestsProvider);
        },
        child: CustomScrollView(
          slivers: [
            // My profile / Become a mentor card
            SliverToBoxAdapter(
              child: myProfileAsync.when(
                data: (profile) {
                  if (profile == null) {
                    return _BecomeMentorCard(
                      onTap: () => _showMentorshipSetup(context, ref),
                    );
                  }
                  return _MyMentorshipCard(profile: profile);
                },
                loading: () => const Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (_, __) => const SizedBox.shrink(),
              ),
            ),

            // Pending requests
            requestsAsync.when(
              data: (requests) {
                if (requests.isEmpty) return const SliverToBoxAdapter(child: SizedBox.shrink());

                return SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          'Pending Requests',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      ...requests.map((request) => _RequestTile(request: request)),
                      const Divider(),
                    ],
                  ),
                );
              },
              loading: () => const SliverToBoxAdapter(child: SizedBox.shrink()),
              error: (_, __) => const SliverToBoxAdapter(child: SizedBox.shrink()),
            ),

            // Available mentors
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Available Mentors',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            mentorsAsync.when(
              data: (mentors) {
                if (mentors.isEmpty) {
                  return SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.school_outlined,
                            size: 64,
                            color: theme.colorScheme.outline,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No mentors available',
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: theme.colorScheme.outline,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => _MentorCard(
                      mentor: mentors[index],
                      onRequestMentorship: () => _showRequestDialog(
                        context,
                        ref,
                        mentors[index],
                      ),
                    ),
                    childCount: mentors.length,
                  ),
                );
              },
              loading: () => const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (e, _) => SliverFillRemaining(
                child: Center(child: Text('Error: $e')),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showMentorshipSetup(BuildContext context, WidgetRef ref) {
    // TODO: Implement mentorship profile setup
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Mentorship setup coming soon')),
    );
  }

  void _showRequestDialog(
    BuildContext context,
    WidgetRef ref,
    MentorshipProfile mentor,
  ) {
    final messageController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Request Mentorship from ${mentor.userName}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Send a message explaining what you would like to learn:',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: messageController,
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: 'I would like to learn more about...',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.pop(context);
              try {
                await ref.read(learningNotifierProvider.notifier).sendMentorshipRequest(
                      mentorId: mentor.userId,
                      message: messageController.text.trim(),
                    );
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Request sent!')),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: $e')),
                  );
                }
              }
            },
            child: const Text('Send Request'),
          ),
        ],
      ),
    );
  }
}

class _BecomeMentorCard extends StatelessWidget {
  const _BecomeMentorCard({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.all(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.school,
                  size: 32,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Become a Mentor',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Share your Human Design knowledge',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.outline,
                      ),
                    ),
                  ],
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

class _MyMentorshipCard extends StatelessWidget {
  const _MyMentorshipCard({required this.profile});

  final MentorshipProfile profile;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Your Profile',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                if (profile.isVerified)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.verified,
                          size: 14,
                          color: theme.colorScheme.primary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Verified',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                if (profile.isMentor)
                  Chip(
                    label: const Text('Mentor'),
                    visualDensity: VisualDensity.compact,
                    avatar: const Icon(Icons.school, size: 16),
                  ),
                if (profile.isMentee) ...[
                  const SizedBox(width: 8),
                  Chip(
                    label: const Text('Mentee'),
                    visualDensity: VisualDensity.compact,
                    avatar: const Icon(Icons.person, size: 16),
                  ),
                ],
              ],
            ),
            if (profile.isMentor) ...[
              const SizedBox(height: 12),
              Text(
                'Mentees: ${profile.currentMenteeCount}/${profile.maxMentees}',
                style: theme.textTheme.bodyMedium,
              ),
              if (profile.rating != null) ...[
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.star, size: 16, color: Colors.amber),
                    const SizedBox(width: 4),
                    Text(
                      '${profile.rating!.toStringAsFixed(1)} (${profile.reviewCount} reviews)',
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }
}

class _MentorCard extends StatelessWidget {
  const _MentorCard({
    required this.mentor,
    required this.onRequestMentorship,
  });

  final MentorshipProfile mentor;
  final VoidCallback onRequestMentorship;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundImage: mentor.userAvatarUrl != null
                      ? NetworkImage(mentor.userAvatarUrl!)
                      : null,
                  child: mentor.userAvatarUrl == null
                      ? Text((mentor.userName ?? 'M')[0].toUpperCase())
                      : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            mentor.userName ?? 'Unknown',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          if (mentor.isVerified) ...[
                            const SizedBox(width: 4),
                            Icon(
                              Icons.verified,
                              size: 16,
                              color: theme.colorScheme.primary,
                            ),
                          ],
                        ],
                      ),
                      if (mentor.userHdType != null)
                        Text(
                          mentor.userHdType!,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.outline,
                          ),
                        ),
                    ],
                  ),
                ),
                if (mentor.rating != null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.star, size: 14, color: Colors.amber),
                        const SizedBox(width: 4),
                        Text(
                          mentor.rating!.toStringAsFixed(1),
                          style: theme.textTheme.labelMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),

            if (mentor.bio != null) ...[
              const SizedBox(height: 12),
              Text(
                mentor.bio!,
                style: theme.textTheme.bodyMedium,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],

            if (mentor.expertiseAreas != null && mentor.expertiseAreas!.isNotEmpty) ...[
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: mentor.expertiseAreas!.take(3).map((area) {
                  return Chip(
                    label: Text(area),
                    visualDensity: VisualDensity.compact,
                    labelStyle: theme.textTheme.labelSmall,
                  );
                }).toList(),
              ),
            ],

            const SizedBox(height: 12),

            Row(
              children: [
                if (mentor.experienceYears != null)
                  Text(
                    '${mentor.experienceYears} years exp',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.outline,
                    ),
                  ),
                const Spacer(),
                if (mentor.hasAvailability)
                  FilledButton.tonal(
                    onPressed: onRequestMentorship,
                    child: const Text('Request'),
                  )
                else
                  OutlinedButton(
                    onPressed: null,
                    child: const Text('Full'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _RequestTile extends ConsumerWidget {
  const _RequestTile({required this.request});

  final MentorshipRequest request;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return ListTile(
      leading: CircleAvatar(
        backgroundImage: request.menteeAvatarUrl != null
            ? NetworkImage(request.menteeAvatarUrl!)
            : null,
        child: request.menteeAvatarUrl == null
            ? Text((request.menteeName ?? 'U')[0].toUpperCase())
            : null,
      ),
      title: Text(request.menteeName ?? 'Unknown'),
      subtitle: Text(
        request.message ?? 'No message',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(Icons.check_circle, color: theme.colorScheme.primary),
            onPressed: () async {
              await ref.read(learningNotifierProvider.notifier).respondToMentorshipRequest(
                    request.id,
                    MentorshipRequestStatus.accepted,
                  );
            },
          ),
          IconButton(
            icon: Icon(Icons.cancel, color: theme.colorScheme.error),
            onPressed: () async {
              await ref.read(learningNotifierProvider.notifier).respondToMentorshipRequest(
                    request.id,
                    MentorshipRequestStatus.declined,
                  );
            },
          ),
        ],
      ),
    );
  }
}
