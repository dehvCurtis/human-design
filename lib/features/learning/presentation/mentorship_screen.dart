import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../../../core/utils/error_handler.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../domain/learning_providers.dart';
import '../domain/models/learning.dart';

class MentorshipScreen extends ConsumerWidget {
  const MentorshipScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final mentorsAsync = ref.watch(mentorsProvider);
    final myProfileAsync = ref.watch(myMentorshipProfileProvider);
    final requestsAsync = ref.watch(pendingMentorshipRequestsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.mentorship_title),
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
                error: (_, _) => const SizedBox.shrink(),
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
                          l10n.mentorship_pendingRequests,
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
              error: (_, _) => const SliverToBoxAdapter(child: SizedBox.shrink()),
            ),

            // Available mentors
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  l10n.mentorship_availableMentors,
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
                            l10n.mentorship_noMentorsAvailable,
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
                child: Center(child: Text(ErrorHandler.getUserMessage(e, context: 'load mentors'))),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showMentorshipSetup(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) => const _MentorshipSetupSheet(),
    );
  }

  void _showRequestDialog(
    BuildContext context,
    WidgetRef ref,
    MentorshipProfile mentor,
  ) {
    final l10n = AppLocalizations.of(context)!;
    final messageController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.mentorship_requestMentorship(mentor.userName ?? '')),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              l10n.mentorship_sendMessage,
              style: Theme.of(dialogContext).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: messageController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: l10n.mentorship_learnPrompt,
                border: const OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(l10n.common_cancel),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.pop(dialogContext);
              try {
                await ref.read(learningNotifierProvider.notifier).sendMentorshipRequest(
                      mentorId: mentor.userId,
                      message: messageController.text.trim(),
                    );
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(l10n.mentorship_requestSent)),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(ErrorHandler.getUserMessage(e, context: 'send request'))),
                  );
                }
              }
            },
            child: Text(l10n.mentorship_sendRequest),
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
    final l10n = AppLocalizations.of(context)!;

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
                      l10n.mentorship_becomeAMentor,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      l10n.mentorship_shareKnowledge,
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

class _MentorshipSetupSheet extends ConsumerStatefulWidget {
  const _MentorshipSetupSheet();

  @override
  ConsumerState<_MentorshipSetupSheet> createState() => _MentorshipSetupSheetState();
}

class _MentorshipSetupSheetState extends ConsumerState<_MentorshipSetupSheet> {
  final _formKey = GlobalKey<FormState>();
  final _bioController = TextEditingController();

  bool _isMentor = false;
  bool _isMentee = true;
  int _experienceYears = 0;
  int _maxMentees = 3;
  final Set<String> _selectedExpertise = {};
  bool _isLoading = false;

  static const _expertiseOptions = [
    'Types & Strategy',
    'Authority',
    'Centers',
    'Gates & Channels',
    'Profiles',
    'Variables',
    'Transits',
    'Relationships',
    'Business & Career',
    'Parenting',
  ];

  @override
  void dispose() {
    _bioController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    if (!_isMentor && !_isMentee) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select at least one role')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await ref.read(learningNotifierProvider.notifier).updateMentorshipProfile(
            isMentor: _isMentor,
            isMentee: _isMentee,
            bio: _bioController.text.trim().isEmpty ? null : _bioController.text.trim(),
            experienceYears: _isMentor ? _experienceYears : null,
            maxMentees: _isMentor ? _maxMentees : null,
            expertiseAreas: _selectedExpertise.isEmpty ? null : _selectedExpertise.toList(),
          );

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Mentorship profile created!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(ErrorHandler.getUserMessage(e, context: 'save profile'))),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) => Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            controller: scrollController,
            children: [
              // Header
              Row(
                children: [
                  Text(
                    'Mentorship Setup',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Set up your mentorship profile to connect with others in the Human Design community.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.outline,
                ),
              ),
              const SizedBox(height: 24),

              // Role selection
              Text(
                'Your Role',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              CheckboxListTile(
                value: _isMentee,
                onChanged: (value) => setState(() => _isMentee = value ?? false),
                title: const Text('Mentee'),
                subtitle: const Text('I want to learn from experienced practitioners'),
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
              ),
              CheckboxListTile(
                value: _isMentor,
                onChanged: (value) => setState(() => _isMentor = value ?? false),
                title: const Text('Mentor'),
                subtitle: const Text('I want to share my knowledge and guide others'),
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
              ),
              const SizedBox(height: 24),

              // Bio
              Text(
                'About You',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _bioController,
                maxLines: 4,
                maxLength: 500,
                decoration: const InputDecoration(
                  hintText: 'Tell others about your Human Design journey...',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),

              // Expertise areas
              Text(
                'Areas of Interest',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _expertiseOptions.map((area) {
                  final isSelected = _selectedExpertise.contains(area);
                  return FilterChip(
                    label: Text(area),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          _selectedExpertise.add(area);
                        } else {
                          _selectedExpertise.remove(area);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),

              // Mentor-specific fields
              if (_isMentor) ...[
                Text(
                  'Mentor Settings',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),

                // Experience years
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Years of Experience'),
                  trailing: SizedBox(
                    width: 120,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove),
                          onPressed: _experienceYears > 0
                              ? () => setState(() => _experienceYears--)
                              : null,
                        ),
                        Text(
                          '$_experienceYears',
                          style: theme.textTheme.titleMedium,
                        ),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () => setState(() => _experienceYears++),
                        ),
                      ],
                    ),
                  ),
                ),

                // Max mentees
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Maximum Mentees'),
                  trailing: SizedBox(
                    width: 120,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove),
                          onPressed: _maxMentees > 1
                              ? () => setState(() => _maxMentees--)
                              : null,
                        ),
                        Text(
                          '$_maxMentees',
                          style: theme.textTheme.titleMedium,
                        ),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: _maxMentees < 10
                              ? () => setState(() => _maxMentees++)
                              : null,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],

              // Save button
              FilledButton(
                onPressed: _isLoading ? null : _saveProfile,
                child: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Create Profile'),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
