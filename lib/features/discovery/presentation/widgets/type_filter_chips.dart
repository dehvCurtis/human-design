import 'package:flutter/material.dart';

import '../../../../l10n/generated/app_localizations.dart';
import '../../domain/models/user_discovery.dart';

class TypeFilterChips extends StatelessWidget {
  const TypeFilterChips({
    super.key,
    required this.filter,
    required this.onFilterChanged,
  });

  final DiscoveryFilter filter;
  final ValueChanged<DiscoveryFilter> onFilterChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final chips = <Widget>[];

    // Type chips
    if (filter.hdTypes != null) {
      for (final type in filter.hdTypes!) {
        chips.add(_FilterChip(
          label: _getShortType(type),
          color: _getTypeColor(type),
          onRemove: () => _removeType(type),
        ));
      }
    }

    // Profile chips
    if (filter.hdProfiles != null) {
      for (final profile in filter.hdProfiles!) {
        chips.add(_FilterChip(
          label: profile,
          color: Colors.purple,
          onRemove: () => _removeProfile(profile),
        ));
      }
    }

    // Authority chips
    if (filter.hdAuthorities != null) {
      for (final authority in filter.hdAuthorities!) {
        chips.add(_FilterChip(
          label: authority,
          color: Colors.indigo,
          onRemove: () => _removeAuthority(authority),
        ));
      }
    }

    // Other filters
    if (filter.showOnlyWithChart) {
      chips.add(_FilterChip(
        label: l10n.discovery_hasChart,
        color: Colors.teal,
        onRemove: () => onFilterChanged(
          filter.copyWith(showOnlyWithChart: false),
        ),
      ));
    }

    if (filter.showOnlyMutualFollows) {
      chips.add(_FilterChip(
        label: l10n.discovery_mutual,
        color: Colors.green,
        onRemove: () => onFilterChanged(
          filter.copyWith(showOnlyMutualFollows: false),
        ),
      ));
    }

    // Clear all button
    if (chips.isNotEmpty) {
      chips.add(
        ActionChip(
          label: Text(l10n.discovery_clearAll),
          onPressed: () => onFilterChanged(const DiscoveryFilter()),
          avatar: const Icon(Icons.clear_all, size: 18),
        ),
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: chips
            .map((chip) => Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: chip,
                ))
            .toList(),
      ),
    );
  }

  void _removeType(String type) {
    final newTypes = List<String>.from(filter.hdTypes ?? [])..remove(type);
    onFilterChanged(filter.copyWith(
      hdTypes: newTypes.isEmpty ? null : newTypes,
    ));
  }

  void _removeProfile(String profile) {
    final newProfiles = List<String>.from(filter.hdProfiles ?? [])
      ..remove(profile);
    onFilterChanged(filter.copyWith(
      hdProfiles: newProfiles.isEmpty ? null : newProfiles,
    ));
  }

  void _removeAuthority(String authority) {
    final newAuthorities = List<String>.from(filter.hdAuthorities ?? [])
      ..remove(authority);
    onFilterChanged(filter.copyWith(
      hdAuthorities: newAuthorities.isEmpty ? null : newAuthorities,
    ));
  }

  String _getShortType(String type) {
    switch (type) {
      case 'Manifesting Generator':
        return 'MG';
      default:
        return type;
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
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.color,
    required this.onRemove,
  });

  final String label;
  final Color color;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
      backgroundColor: color.withValues(alpha: 0.1),
      side: BorderSide(color: color.withValues(alpha: 0.3)),
      deleteIcon: Icon(Icons.close, size: 16, color: color),
      onDeleted: onRemove,
      visualDensity: VisualDensity.compact,
      padding: const EdgeInsets.symmetric(horizontal: 4),
    );
  }
}
