import 'package:flutter/material.dart';

import '../../../../core/constants/human_design_constants.dart';
import '../../../../l10n/generated/app_localizations.dart';

/// Bottom sheet for selecting a gate or channel to tag in a post
class GateChannelPickerSheet extends StatefulWidget {
  const GateChannelPickerSheet({
    super.key,
    this.initialGate,
    this.initialChannel,
    required this.onGateSelected,
    required this.onChannelSelected,
  });

  final int? initialGate;
  final String? initialChannel;
  final void Function(int gate) onGateSelected;
  final void Function(String channelId) onChannelSelected;

  @override
  State<GateChannelPickerSheet> createState() => _GateChannelPickerSheetState();
}

class _GateChannelPickerSheetState extends State<GateChannelPickerSheet>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
      });
    });
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
    final mediaQuery = MediaQuery.of(context);

    return Container(
      height: mediaQuery.size.height * 0.75,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 12),
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
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(l10n.common_cancel),
                ),
                Text(
                  'Tag Gate or Channel',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 72), // Balance the cancel button
              ],
            ),
          ),

          // Search bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: l10n.feed_searchGatesChannels,
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: theme.colorScheme.surfaceContainerHighest,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),
          ),

          const SizedBox(height: 8),

          // Tab bar
          TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: 'Gates (64)'),
              Tab(text: 'Channels (36)'),
            ],
          ),

          // Tab content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildGatesList(theme),
                _buildChannelsList(theme),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGatesList(ThemeData theme) {
    final filteredGates = gates.entries.where((entry) {
      if (_searchQuery.isEmpty) return true;
      final gate = entry.value;
      return gate.number.toString().contains(_searchQuery) ||
          gate.name.toLowerCase().contains(_searchQuery) ||
          gate.keynote.toLowerCase().contains(_searchQuery) ||
          gate.center.displayName.toLowerCase().contains(_searchQuery);
    }).toList();

    if (filteredGates.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.search_off,
              size: 48,
              color: theme.colorScheme.outline,
            ),
            const SizedBox(height: 16),
            Text(
              'No gates found',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.outline,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: filteredGates.length,
      itemBuilder: (context, index) {
        final entry = filteredGates[index];
        final gate = entry.value;
        final isSelected = widget.initialGate == gate.number;

        return ListTile(
          leading: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: isSelected
                  ? theme.colorScheme.primary
                  : theme.colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                '${gate.number}',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isSelected
                      ? theme.colorScheme.onPrimary
                      : theme.colorScheme.onPrimaryContainer,
                ),
              ),
            ),
          ),
          title: Text(
            gate.name,
            style: theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: theme.colorScheme.secondaryContainer,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  gate.center.displayName,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSecondaryContainer,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  gate.keynote,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          trailing: isSelected
              ? Icon(
                  Icons.check_circle,
                  color: theme.colorScheme.primary,
                )
              : null,
          onTap: () => widget.onGateSelected(gate.number),
        );
      },
    );
  }

  Widget _buildChannelsList(ThemeData theme) {
    final filteredChannels = channels.where((channel) {
      if (_searchQuery.isEmpty) return true;
      return channel.name.toLowerCase().contains(_searchQuery) ||
          channel.id.contains(_searchQuery) ||
          channel.gate1.toString().contains(_searchQuery) ||
          channel.gate2.toString().contains(_searchQuery) ||
          channel.type.toLowerCase().contains(_searchQuery);
    }).toList();

    if (filteredChannels.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.search_off,
              size: 48,
              color: theme.colorScheme.outline,
            ),
            const SizedBox(height: 16),
            Text(
              'No channels found',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.outline,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: filteredChannels.length,
      itemBuilder: (context, index) {
        final channel = filteredChannels[index];
        final isSelected = widget.initialChannel == channel.id;

        return ListTile(
          leading: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: isSelected
                  ? theme.colorScheme.primary
                  : theme.colorScheme.tertiaryContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                '${channel.gate1}-${channel.gate2}',
                style: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isSelected
                      ? theme.colorScheme.onPrimary
                      : theme.colorScheme.onTertiaryContainer,
                ),
              ),
            ),
          ),
          title: Text(
            channel.name,
            style: theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: _getChannelTypeColor(channel.type, theme),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  channel.type,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSecondaryContainer,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Gates ${channel.gate1} & ${channel.gate2}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          trailing: isSelected
              ? Icon(
                  Icons.check_circle,
                  color: theme.colorScheme.primary,
                )
              : null,
          onTap: () => widget.onChannelSelected(channel.id),
        );
      },
    );
  }

  Color _getChannelTypeColor(String type, ThemeData theme) {
    switch (type.toLowerCase()) {
      case 'individual':
        return theme.colorScheme.primaryContainer;
      case 'collective':
        return theme.colorScheme.secondaryContainer;
      case 'tribal':
        return theme.colorScheme.tertiaryContainer;
      case 'integration':
        return theme.colorScheme.surfaceContainerHighest;
      default:
        return theme.colorScheme.surfaceContainerHighest;
    }
  }
}
