import 'dart:async';

import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

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

/// Mock location search provider for development
class MockLocationSearchProvider implements LocationSearchProvider {
  static const _mockLocations = [
    // United States
    LocationResult(
      name: 'New York',
      displayName: 'New York, NY, United States',
      latitude: 40.7128,
      longitude: -74.0060,
      country: 'United States',
      timezone: 'America/New_York',
    ),
    LocationResult(
      name: 'Los Angeles',
      displayName: 'Los Angeles, CA, United States',
      latitude: 34.0522,
      longitude: -118.2437,
      country: 'United States',
      timezone: 'America/Los_Angeles',
    ),
    LocationResult(
      name: 'Chicago',
      displayName: 'Chicago, IL, United States',
      latitude: 41.8781,
      longitude: -87.6298,
      country: 'United States',
      timezone: 'America/Chicago',
    ),
    LocationResult(
      name: 'Houston',
      displayName: 'Houston, TX, United States',
      latitude: 29.7604,
      longitude: -95.3698,
      country: 'United States',
      timezone: 'America/Chicago',
    ),
    LocationResult(
      name: 'Phoenix',
      displayName: 'Phoenix, AZ, United States',
      latitude: 33.4484,
      longitude: -112.0740,
      country: 'United States',
      timezone: 'America/Phoenix',
    ),
    LocationResult(
      name: 'San Francisco',
      displayName: 'San Francisco, CA, United States',
      latitude: 37.7749,
      longitude: -122.4194,
      country: 'United States',
      timezone: 'America/Los_Angeles',
    ),
    LocationResult(
      name: 'Salt Lake City',
      displayName: 'Salt Lake City, Utah, United States',
      latitude: 40.7608,
      longitude: -111.8910,
      country: 'United States',
      timezone: 'America/Denver',
    ),
    LocationResult(
      name: 'Denver',
      displayName: 'Denver, CO, United States',
      latitude: 39.7392,
      longitude: -104.9903,
      country: 'United States',
      timezone: 'America/Denver',
    ),
    LocationResult(
      name: 'Seattle',
      displayName: 'Seattle, WA, United States',
      latitude: 47.6062,
      longitude: -122.3321,
      country: 'United States',
      timezone: 'America/Los_Angeles',
    ),
    LocationResult(
      name: 'Miami',
      displayName: 'Miami, FL, United States',
      latitude: 25.7617,
      longitude: -80.1918,
      country: 'United States',
      timezone: 'America/New_York',
    ),
    LocationResult(
      name: 'Boston',
      displayName: 'Boston, MA, United States',
      latitude: 42.3601,
      longitude: -71.0589,
      country: 'United States',
      timezone: 'America/New_York',
    ),
    LocationResult(
      name: 'Atlanta',
      displayName: 'Atlanta, GA, United States',
      latitude: 33.7490,
      longitude: -84.3880,
      country: 'United States',
      timezone: 'America/New_York',
    ),
    LocationResult(
      name: 'Dallas',
      displayName: 'Dallas, TX, United States',
      latitude: 32.7767,
      longitude: -96.7970,
      country: 'United States',
      timezone: 'America/Chicago',
    ),
    LocationResult(
      name: 'Austin',
      displayName: 'Austin, TX, United States',
      latitude: 30.2672,
      longitude: -97.7431,
      country: 'United States',
      timezone: 'America/Chicago',
    ),
    LocationResult(
      name: 'Las Vegas',
      displayName: 'Las Vegas, NV, United States',
      latitude: 36.1699,
      longitude: -115.1398,
      country: 'United States',
      timezone: 'America/Los_Angeles',
    ),
    LocationResult(
      name: 'Portland',
      displayName: 'Portland, OR, United States',
      latitude: 45.5152,
      longitude: -122.6784,
      country: 'United States',
      timezone: 'America/Los_Angeles',
    ),
    LocationResult(
      name: 'San Diego',
      displayName: 'San Diego, CA, United States',
      latitude: 32.7157,
      longitude: -117.1611,
      country: 'United States',
      timezone: 'America/Los_Angeles',
    ),
    // Europe
    LocationResult(
      name: 'London',
      displayName: 'London, United Kingdom',
      latitude: 51.5074,
      longitude: -0.1278,
      country: 'United Kingdom',
      timezone: 'Europe/London',
    ),
    LocationResult(
      name: 'Paris',
      displayName: 'Paris, France',
      latitude: 48.8566,
      longitude: 2.3522,
      country: 'France',
      timezone: 'Europe/Paris',
    ),
    LocationResult(
      name: 'Berlin',
      displayName: 'Berlin, Germany',
      latitude: 52.5200,
      longitude: 13.4050,
      country: 'Germany',
      timezone: 'Europe/Berlin',
    ),
    LocationResult(
      name: 'Madrid',
      displayName: 'Madrid, Spain',
      latitude: 40.4168,
      longitude: -3.7038,
      country: 'Spain',
      timezone: 'Europe/Madrid',
    ),
    LocationResult(
      name: 'Rome',
      displayName: 'Rome, Italy',
      latitude: 41.9028,
      longitude: 12.4964,
      country: 'Italy',
      timezone: 'Europe/Rome',
    ),
    LocationResult(
      name: 'Amsterdam',
      displayName: 'Amsterdam, Netherlands',
      latitude: 52.3676,
      longitude: 4.9041,
      country: 'Netherlands',
      timezone: 'Europe/Amsterdam',
    ),
    LocationResult(
      name: 'Moscow',
      displayName: 'Moscow, Russia',
      latitude: 55.7558,
      longitude: 37.6173,
      country: 'Russia',
      timezone: 'Europe/Moscow',
    ),
    LocationResult(
      name: 'Kyiv',
      displayName: 'Kyiv, Ukraine',
      latitude: 50.4501,
      longitude: 30.5234,
      country: 'Ukraine',
      timezone: 'Europe/Kyiv',
    ),
    LocationResult(
      name: 'Warsaw',
      displayName: 'Warsaw, Poland',
      latitude: 52.2297,
      longitude: 21.0122,
      country: 'Poland',
      timezone: 'Europe/Warsaw',
    ),
    LocationResult(
      name: 'Vienna',
      displayName: 'Vienna, Austria',
      latitude: 48.2082,
      longitude: 16.3738,
      country: 'Austria',
      timezone: 'Europe/Vienna',
    ),
    LocationResult(
      name: 'Prague',
      displayName: 'Prague, Czech Republic',
      latitude: 50.0755,
      longitude: 14.4378,
      country: 'Czech Republic',
      timezone: 'Europe/Prague',
    ),
    LocationResult(
      name: 'Stockholm',
      displayName: 'Stockholm, Sweden',
      latitude: 59.3293,
      longitude: 18.0686,
      country: 'Sweden',
      timezone: 'Europe/Stockholm',
    ),
    // Asia
    LocationResult(
      name: 'Tokyo',
      displayName: 'Tokyo, Japan',
      latitude: 35.6762,
      longitude: 139.6503,
      country: 'Japan',
      timezone: 'Asia/Tokyo',
    ),
    LocationResult(
      name: 'Beijing',
      displayName: 'Beijing, China',
      latitude: 39.9042,
      longitude: 116.4074,
      country: 'China',
      timezone: 'Asia/Shanghai',
    ),
    LocationResult(
      name: 'Shanghai',
      displayName: 'Shanghai, China',
      latitude: 31.2304,
      longitude: 121.4737,
      country: 'China',
      timezone: 'Asia/Shanghai',
    ),
    LocationResult(
      name: 'Hong Kong',
      displayName: 'Hong Kong, China',
      latitude: 22.3193,
      longitude: 114.1694,
      country: 'China',
      timezone: 'Asia/Hong_Kong',
    ),
    LocationResult(
      name: 'Singapore',
      displayName: 'Singapore',
      latitude: 1.3521,
      longitude: 103.8198,
      country: 'Singapore',
      timezone: 'Asia/Singapore',
    ),
    LocationResult(
      name: 'Seoul',
      displayName: 'Seoul, South Korea',
      latitude: 37.5665,
      longitude: 126.9780,
      country: 'South Korea',
      timezone: 'Asia/Seoul',
    ),
    LocationResult(
      name: 'Mumbai',
      displayName: 'Mumbai, India',
      latitude: 19.0760,
      longitude: 72.8777,
      country: 'India',
      timezone: 'Asia/Kolkata',
    ),
    LocationResult(
      name: 'Delhi',
      displayName: 'Delhi, India',
      latitude: 28.7041,
      longitude: 77.1025,
      country: 'India',
      timezone: 'Asia/Kolkata',
    ),
    LocationResult(
      name: 'Dubai',
      displayName: 'Dubai, United Arab Emirates',
      latitude: 25.2048,
      longitude: 55.2708,
      country: 'United Arab Emirates',
      timezone: 'Asia/Dubai',
    ),
    LocationResult(
      name: 'Bangkok',
      displayName: 'Bangkok, Thailand',
      latitude: 13.7563,
      longitude: 100.5018,
      country: 'Thailand',
      timezone: 'Asia/Bangkok',
    ),
    // Australia & Oceania
    LocationResult(
      name: 'Sydney',
      displayName: 'Sydney, NSW, Australia',
      latitude: -33.8688,
      longitude: 151.2093,
      country: 'Australia',
      timezone: 'Australia/Sydney',
    ),
    LocationResult(
      name: 'Melbourne',
      displayName: 'Melbourne, VIC, Australia',
      latitude: -37.8136,
      longitude: 144.9631,
      country: 'Australia',
      timezone: 'Australia/Melbourne',
    ),
    LocationResult(
      name: 'Brisbane',
      displayName: 'Brisbane, QLD, Australia',
      latitude: -27.4698,
      longitude: 153.0251,
      country: 'Australia',
      timezone: 'Australia/Brisbane',
    ),
    LocationResult(
      name: 'Auckland',
      displayName: 'Auckland, New Zealand',
      latitude: -36.8509,
      longitude: 174.7645,
      country: 'New Zealand',
      timezone: 'Pacific/Auckland',
    ),
    // South America
    LocationResult(
      name: 'São Paulo',
      displayName: 'São Paulo, Brazil',
      latitude: -23.5505,
      longitude: -46.6333,
      country: 'Brazil',
      timezone: 'America/Sao_Paulo',
    ),
    LocationResult(
      name: 'Rio de Janeiro',
      displayName: 'Rio de Janeiro, Brazil',
      latitude: -22.9068,
      longitude: -43.1729,
      country: 'Brazil',
      timezone: 'America/Sao_Paulo',
    ),
    LocationResult(
      name: 'Buenos Aires',
      displayName: 'Buenos Aires, Argentina',
      latitude: -34.6037,
      longitude: -58.3816,
      country: 'Argentina',
      timezone: 'America/Argentina/Buenos_Aires',
    ),
    LocationResult(
      name: 'Mexico City',
      displayName: 'Mexico City, Mexico',
      latitude: 19.4326,
      longitude: -99.1332,
      country: 'Mexico',
      timezone: 'America/Mexico_City',
    ),
    // Canada
    LocationResult(
      name: 'Toronto',
      displayName: 'Toronto, ON, Canada',
      latitude: 43.6532,
      longitude: -79.3832,
      country: 'Canada',
      timezone: 'America/Toronto',
    ),
    LocationResult(
      name: 'Vancouver',
      displayName: 'Vancouver, BC, Canada',
      latitude: 49.2827,
      longitude: -123.1207,
      country: 'Canada',
      timezone: 'America/Vancouver',
    ),
    LocationResult(
      name: 'Montreal',
      displayName: 'Montreal, QC, Canada',
      latitude: 45.5017,
      longitude: -73.5673,
      country: 'Canada',
      timezone: 'America/Montreal',
    ),
    // Africa
    LocationResult(
      name: 'Cairo',
      displayName: 'Cairo, Egypt',
      latitude: 30.0444,
      longitude: 31.2357,
      country: 'Egypt',
      timezone: 'Africa/Cairo',
    ),
    LocationResult(
      name: 'Cape Town',
      displayName: 'Cape Town, South Africa',
      latitude: -33.9249,
      longitude: 18.4241,
      country: 'South Africa',
      timezone: 'Africa/Johannesburg',
    ),
    LocationResult(
      name: 'Johannesburg',
      displayName: 'Johannesburg, South Africa',
      latitude: -26.2041,
      longitude: 28.0473,
      country: 'South Africa',
      timezone: 'Africa/Johannesburg',
    ),
  ];

  @override
  Future<List<LocationResult>> search(String query) async {
    await Future.delayed(const Duration(milliseconds: 300));

    if (query.isEmpty) return [];

    final lowerQuery = query.toLowerCase();
    return _mockLocations
        .where((loc) =>
            loc.name.toLowerCase().contains(lowerQuery) ||
            loc.displayName.toLowerCase().contains(lowerQuery) ||
            (loc.country?.toLowerCase().contains(lowerQuery) ?? false))
        .toList();
  }
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
    this.searchProvider,
    this.debounceMs = 500,
  });

  final LocationResult? value;
  final void Function(LocationResult) onChanged;
  final String? label;
  final String hint;
  final bool enabled;
  final String? errorText;
  final String? helperText;
  final LocationSearchProvider? searchProvider;
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
    _searchProvider = widget.searchProvider ?? MockLocationSearchProvider();
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
              ? 'Network error. Check your connection.'
              : 'Search failed. Please try again.';
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
                                'No cities found. Try a different search.',
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
    this.searchProvider,
  });

  final LocationResult? value;
  final void Function(LocationResult) onChanged;
  final String? label;
  final String hint;
  final bool enabled;
  final String? errorText;
  final LocationSearchProvider? searchProvider;

  @override
  Widget build(BuildContext context) {
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
          helperText: 'Your timezone will be detected automatically',
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
                'Timezone: ${value!.timezone}',
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
