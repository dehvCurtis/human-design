import 'dart:async';

import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../l10n/generated/app_localizations.dart';

/// Location data model
class LocationResult {
  const LocationResult({
    required this.name,
    required this.displayName,
    required this.latitude,
    required this.longitude,
    this.country,
    this.timezone,
  });

  final String name;
  final String displayName;
  final double latitude;
  final double longitude;
  final String? country;
  final String? timezone;

  @override
  String toString() => displayName;
}

/// Location search provider interface
abstract class LocationSearchProvider {
  Future<List<LocationResult>> search(String query);
}

/// A location search field with autocomplete
class LocationSearchField extends StatefulWidget {
  const LocationSearchField({
    super.key,
    required this.value,
    required this.onChanged,
    this.label,
    this.hint = 'Search for a city',
    this.enabled = true,
    this.errorText,
    this.helperText,
    required this.searchProvider,
    this.debounceMs = 500,
  });

  final LocationResult? value;
  final void Function(LocationResult) onChanged;
  final String? label;
  final String hint;
  final bool enabled;
  final String? errorText;
  final String? helperText;
  final LocationSearchProvider searchProvider;
  final int debounceMs;

  @override
  State<LocationSearchField> createState() => _LocationSearchFieldState();
}

class _LocationSearchFieldState extends State<LocationSearchField> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  late final LocationSearchProvider _searchProvider;

  List<LocationResult> _suggestions = [];
  bool _isLoading = false;
  bool _showSuggestions = false;
  bool _hasSearched = false;
  String? _searchError;
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    _searchProvider = widget.searchProvider;
    if (widget.value != null) {
      _controller.text = widget.value!.displayName;
    }
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void didUpdateWidget(LocationSearchField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value && widget.value != null) {
      _controller.text = widget.value!.displayName;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _onFocusChange() {
    if (!_focusNode.hasFocus) {
      Future.delayed(const Duration(milliseconds: 200), () {
        if (mounted) {
          setState(() => _showSuggestions = false);
        }
      });
    }
  }

  void _onSearchChanged(String query) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(Duration(milliseconds: widget.debounceMs), () {
      _performSearch(query);
    });
  }

  Future<void> _performSearch(String query) async {
    if (query.length < 2) {
      setState(() {
        _suggestions = [];
        _showSuggestions = false;
        _hasSearched = false;
        _searchError = null;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _searchError = null;
    });

    try {
      final results = await _searchProvider.search(query);
      if (mounted) {
        setState(() {
          _suggestions = results;
          _showSuggestions = true;
          _hasSearched = true;
          _isLoading = false;
          _searchError = null;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _suggestions = [];
          _showSuggestions = true;
          _hasSearched = true;
          _isLoading = false;
          _searchError = e.toString().contains('Network')
              ? AppLocalizations.of(context)!.form_networkError
              : AppLocalizations.of(context)!.form_searchFailed;
        });
      }
    }
  }

  void _selectLocation(LocationResult location) {
    _controller.text = location.displayName;
    widget.onChanged(location);
    setState(() => _showSuggestions = false);
    _focusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: theme.textTheme.titleSmall?.copyWith(
              color: isDark
                  ? AppColors.textSecondaryDark
                  : AppColors.textSecondaryLight,
            ),
          ),
          const SizedBox(height: 8),
        ],
        TextFormField(
          controller: _controller,
          focusNode: _focusNode,
          enabled: widget.enabled,
          onChanged: _onSearchChanged,
          decoration: InputDecoration(
            hintText: widget.hint,
            errorText: widget.errorText,
            helperText: widget.helperText,
            prefixIcon: const Icon(Icons.location_on_outlined),
            suffixIcon: _isLoading
                ? const Padding(
                    padding: EdgeInsets.all(12),
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  )
                : (_controller.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _controller.clear();
                          setState(() {
                            _suggestions = [];
                            _showSuggestions = false;
                          });
                        },
                      )
                    : null),
          ),
        ),
        if (_showSuggestions) ...[
          const SizedBox(height: 4),
          Container(
            constraints: const BoxConstraints(maxHeight: 200),
            decoration: BoxDecoration(
              color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(25),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: _searchError != null
                ? Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 20,
                          color: isDark
                              ? AppColors.textSecondaryDark
                              : AppColors.textSecondaryLight,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            _searchError!,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: isDark
                                  ? AppColors.textSecondaryDark
                                  : AppColors.textSecondaryLight,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : _suggestions.isEmpty && _hasSearched
                    ? Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Icon(
                              Icons.search_off,
                              size: 20,
                              color: isDark
                                  ? AppColors.textSecondaryDark
                                  : AppColors.textSecondaryLight,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                l10n.form_noCitiesFound,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: isDark
                                      ? AppColors.textSecondaryDark
                                      : AppColors.textSecondaryLight,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        itemCount: _suggestions.length,
                        itemBuilder: (context, index) {
                          final location = _suggestions[index];
                          return ListTile(
                            dense: true,
                            leading: const Icon(Icons.location_city, size: 20),
                            title: Text(location.name),
                            subtitle: Text(
                              location.country ?? '',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: isDark
                                    ? AppColors.textSecondaryDark
                                    : AppColors.textSecondaryLight,
                              ),
                            ),
                            onTap: () => _selectLocation(location),
                          );
                        },
                      ),
          ),
        ],
      ],
    );
  }
}

/// Birth location picker with timezone detection
class BirthLocationField extends StatelessWidget {
  const BirthLocationField({
    super.key,
    required this.value,
    required this.onChanged,
    this.label = 'Birth Location',
    this.hint = 'Search for your birth city',
    this.enabled = true,
    this.errorText,
    required this.searchProvider,
  });

  final LocationResult? value;
  final void Function(LocationResult) onChanged;
  final String? label;
  final String hint;
  final bool enabled;
  final String? errorText;
  final LocationSearchProvider searchProvider;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        LocationSearchField(
          value: value,
          onChanged: onChanged,
          label: label,
          hint: hint,
          enabled: enabled,
          errorText: errorText,
          helperText: l10n.form_timezoneAuto,
          searchProvider: searchProvider,
        ),
        if (value != null && value!.timezone != null) ...[
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                Icons.schedule,
                size: 16,
                color: Theme.of(context).brightness == Brightness.dark
                    ? AppColors.textSecondaryDark
                    : AppColors.textSecondaryLight,
              ),
              const SizedBox(width: 8),
              Text(
                l10n.form_timezoneValue(value!.timezone!),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? AppColors.textSecondaryDark
                          : AppColors.textSecondaryLight,
                    ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}
