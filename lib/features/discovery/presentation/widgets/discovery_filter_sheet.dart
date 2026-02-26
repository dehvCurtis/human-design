// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../l10n/generated/app_localizations.dart';
import '../../domain/models/user_discovery.dart';
import '../../domain/discovery_providers.dart';

class DiscoveryFilterSheet extends ConsumerStatefulWidget {
  const DiscoveryFilterSheet({super.key});

  @override
  ConsumerState<DiscoveryFilterSheet> createState() =>
      _DiscoveryFilterSheetState();
}

class _DiscoveryFilterSheetState extends ConsumerState<DiscoveryFilterSheet> {
  late DiscoveryFilter _filter;

  @override
  void initState() {
    super.initState();
    _filter = ref.read(discoveryFilterProvider);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return DraggableScrollableSheet(
      initialChildSize: 0.7,
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
              Center(
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Filter Discovery',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _filter = const DiscoveryFilter();
                        });
                      },
                      child: Text(l10n.common_reset),
                    ),
                  ],
                ),
              ),

              const Divider(),

              // Filter options
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(16),
                  children: [
                    // HD Type filter
                    _FilterSection(
                      title: 'Human Design Type',
                      children: [
                        _buildTypeOptions(),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Profile filter
                    _FilterSection(
                      title: 'Profile',
                      children: [
                        _buildProfileOptions(),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Authority filter
                    _FilterSection(
                      title: 'Authority',
                      children: [
                        _buildAuthorityOptions(),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Sort by
                    _FilterSection(
                      title: 'Sort By',
                      children: [
                        _buildSortOptions(),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Additional options
                    _FilterSection(
                      title: 'Additional Filters',
                      children: [
                        SwitchListTile(
                          title: Text(l10n.discovery_onlyWithChart),
                          subtitle:
                              Text(l10n.discovery_showWithBirthData),
                          value: _filter.showOnlyWithChart,
                          onChanged: (value) {
                            setState(() {
                              _filter = _filter.copyWith(showOnlyWithChart: value);
                            });
                          },
                        ),
                        SwitchListTile(
                          title: Text(l10n.discovery_mutualFollowsOnly),
                          subtitle: Text(l10n.discovery_showMutualFollows),
                          value: _filter.showOnlyMutualFollows,
                          onChanged: (value) {
                            setState(() {
                              _filter =
                                  _filter.copyWith(showOnlyMutualFollows: value);
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Apply button
              Padding(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () {
                      ref.read(discoveryFilterProvider.notifier).state = _filter;
                      Navigator.pop(context);
                    },
                    child: Text(l10n.discovery_applyFilters),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTypeOptions() {
    const types = [
      'Generator',
      'Manifesting Generator',
      'Projector',
      'Manifestor',
      'Reflector',
    ];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: types.map((type) {
        final isSelected = _filter.hdTypes?.contains(type) ?? false;
        final color = _getTypeColor(type);

        return FilterChip(
          label: Text(_getShortType(type)),
          selected: isSelected,
          selectedColor: color.withValues(alpha: 0.2),
          checkmarkColor: color,
          side: BorderSide(
            color: isSelected ? color : Colors.grey.withValues(alpha: 0.3),
          ),
          onSelected: (selected) {
            setState(() {
              final currentTypes =
                  List<String>.from(_filter.hdTypes ?? <String>[]);
              if (selected) {
                currentTypes.add(type);
              } else {
                currentTypes.remove(type);
              }
              _filter = _filter.copyWith(
                hdTypes: currentTypes.isEmpty ? null : currentTypes,
              );
            });
          },
        );
      }).toList(),
    );
  }

  Widget _buildProfileOptions() {
    const profiles = [
      '1/3',
      '1/4',
      '2/4',
      '2/5',
      '3/5',
      '3/6',
      '4/6',
      '4/1',
      '5/1',
      '5/2',
      '6/2',
      '6/3',
    ];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: profiles.map((profile) {
        final isSelected = _filter.hdProfiles?.contains(profile) ?? false;

        return FilterChip(
          label: Text(profile),
          selected: isSelected,
          onSelected: (selected) {
            setState(() {
              final currentProfiles =
                  List<String>.from(_filter.hdProfiles ?? <String>[]);
              if (selected) {
                currentProfiles.add(profile);
              } else {
                currentProfiles.remove(profile);
              }
              _filter = _filter.copyWith(
                hdProfiles: currentProfiles.isEmpty ? null : currentProfiles,
              );
            });
          },
        );
      }).toList(),
    );
  }

  Widget _buildAuthorityOptions() {
    const authorities = [
      'Emotional',
      'Sacral',
      'Splenic',
      'Ego',
      'Self-Projected',
      'Environment',
      'Lunar',
    ];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: authorities.map((authority) {
        final isSelected = _filter.hdAuthorities?.contains(authority) ?? false;

        return FilterChip(
          label: Text(authority),
          selected: isSelected,
          onSelected: (selected) {
            setState(() {
              final currentAuthorities =
                  List<String>.from(_filter.hdAuthorities ?? <String>[]);
              if (selected) {
                currentAuthorities.add(authority);
              } else {
                currentAuthorities.remove(authority);
              }
              _filter = _filter.copyWith(
                hdAuthorities:
                    currentAuthorities.isEmpty ? null : currentAuthorities,
              );
            });
          },
        );
      }).toList(),
    );
  }

  Widget _buildSortOptions() {
    return Column(
      children: DiscoverySortBy.values.map((sortBy) {
        return RadioListTile<DiscoverySortBy>(
          title: Text(_getSortByLabel(sortBy)),
          subtitle: Text(_getSortByDescription(sortBy)),
          value: sortBy,
          groupValue: _filter.sortBy,
          onChanged: (value) {
            if (value != null) {
              setState(() {
                _filter = _filter.copyWith(sortBy: value);
              });
            }
          },
        );
      }).toList(),
    );
  }

  String _getSortByLabel(DiscoverySortBy sortBy) {
    switch (sortBy) {
      case DiscoverySortBy.relevance:
        return 'Relevance';
      case DiscoverySortBy.compatibility:
        return 'Compatibility';
      case DiscoverySortBy.recent:
        return 'Recently Joined';
      case DiscoverySortBy.followers:
        return 'Most Followers';
      case DiscoverySortBy.name:
        return 'Name (A-Z)';
    }
  }

  String _getSortByDescription(DiscoverySortBy sortBy) {
    switch (sortBy) {
      case DiscoverySortBy.relevance:
        return 'Balanced mix of factors';
      case DiscoverySortBy.compatibility:
        return 'Based on HD chart compatibility';
      case DiscoverySortBy.recent:
        return 'Newest members first';
      case DiscoverySortBy.followers:
        return 'Most popular users';
      case DiscoverySortBy.name:
        return 'Alphabetical order';
    }
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

class _FilterSection extends StatelessWidget {
  const _FilterSection({
    required this.title,
    required this.children,
  });

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        ...children,
      ],
    );
  }
}
