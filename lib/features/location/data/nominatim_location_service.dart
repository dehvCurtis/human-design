import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:lat_lng_to_timezone/lat_lng_to_timezone.dart' as tz_lookup;

import '../../../shared/widgets/forms/location_search_field.dart';

/// Location search provider using OpenStreetMap Nominatim API
///
/// Nominatim usage policy requires:
/// - Max 1 request per second
/// - User-Agent header identifying the app
/// - No bulk/automated requests
class NominatimLocationSearchProvider implements LocationSearchProvider {
  NominatimLocationSearchProvider({
    http.Client? httpClient,
  }) : _httpClient = httpClient ?? http.Client();

  final http.Client _httpClient;

  /// Rate limiting: track last request time
  DateTime? _lastRequestTime;

  /// Minimum delay between requests (Nominatim policy: 1 request/second)
  static const _minRequestInterval = Duration(milliseconds: 1000);

  /// User agent for Nominatim (required by usage policy)
  static const _userAgent = 'HumanDesignApp/1.0 (Flutter)';

  @override
  Future<List<LocationResult>> search(String query) async {
    if (query.trim().length < 2) {
      return [];
    }

    // Rate limiting: wait if needed
    await _enforceRateLimit();

    try {
      final uri = Uri.https(
        'nominatim.openstreetmap.org',
        '/search',
        {
          'q': query,
          'format': 'json',
          'limit': '10',
          'addressdetails': '1',
          // Filter to populated places for better city results
          'featuretype': 'city',
        },
      );

      final response = await _httpClient.get(
        uri,
        headers: {'User-Agent': _userAgent},
      ).timeout(const Duration(seconds: 10));

      _lastRequestTime = DateTime.now();

      if (response.statusCode != 200) {
        throw NominatimException(
          'Search failed with status ${response.statusCode}',
        );
      }

      final List<dynamic> data = json.decode(response.body);

      if (data.isEmpty) {
        // Try again without featuretype filter for broader results
        return _searchBroad(query);
      }

      return _parseResults(data);
    } on http.ClientException catch (e) {
      throw NominatimException('Network error: ${e.message}');
    } on TimeoutException {
      throw NominatimException('Request timed out');
    } on FormatException {
      throw NominatimException('Invalid response format');
    }
  }

  /// Broader search without city filter when initial search returns empty
  Future<List<LocationResult>> _searchBroad(String query) async {
    await _enforceRateLimit();

    try {
      final uri = Uri.https(
        'nominatim.openstreetmap.org',
        '/search',
        {
          'q': query,
          'format': 'json',
          'limit': '10',
          'addressdetails': '1',
        },
      );

      final response = await _httpClient.get(
        uri,
        headers: {'User-Agent': _userAgent},
      ).timeout(const Duration(seconds: 10));

      _lastRequestTime = DateTime.now();

      if (response.statusCode != 200) {
        throw NominatimException(
          'Search failed with status ${response.statusCode}',
        );
      }

      final List<dynamic> data = json.decode(response.body);
      return _parseResults(data);
    } on http.ClientException catch (e) {
      throw NominatimException('Network error: ${e.message}');
    } on TimeoutException {
      throw NominatimException('Request timed out');
    } on FormatException {
      throw NominatimException('Invalid response format');
    }
  }

  List<LocationResult> _parseResults(List<dynamic> data) {
    final results = <LocationResult>[];

    for (final item in data) {
      try {
        final lat = double.parse(item['lat'].toString());
        final lon = double.parse(item['lon'].toString());

        // Get timezone from coordinates using offline lookup
        final timezone = tz_lookup.latLngToTimezoneString(lat, lon);

        final address = item['address'] as Map<String, dynamic>? ?? {};

        // Extract city name (try multiple fields)
        final cityName = address['city'] ??
            address['town'] ??
            address['village'] ??
            address['municipality'] ??
            address['county'] ??
            item['name'] ??
            '';

        // Extract country
        final country = address['country'] ?? '';

        // Build display name
        final displayName = item['display_name'] ?? '$cityName, $country';

        results.add(LocationResult(
          name: cityName.toString(),
          displayName: displayName.toString(),
          latitude: lat,
          longitude: lon,
          country: country.toString(),
          timezone: timezone,
        ));
      } catch (_) {
        // Skip invalid entries
        continue;
      }
    }

    return results;
  }

  /// Enforce rate limiting by waiting if the last request was too recent
  Future<void> _enforceRateLimit() async {
    if (_lastRequestTime == null) return;

    final elapsed = DateTime.now().difference(_lastRequestTime!);
    if (elapsed < _minRequestInterval) {
      final waitTime = _minRequestInterval - elapsed;
      await Future.delayed(waitTime);
    }
  }
}

/// Exception thrown when Nominatim API encounters an error
class NominatimException implements Exception {
  const NominatimException(this.message);

  final String message;

  @override
  String toString() => 'NominatimException: $message';
}
