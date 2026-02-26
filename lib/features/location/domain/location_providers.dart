import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/widgets/forms/location_search_field.dart';
import '../../settings/domain/settings_providers.dart';
import '../data/nominatim_location_service.dart';

/// Provider for the location search service
///
/// Uses Nominatim (OpenStreetMap) for worldwide city search with
/// automatic timezone detection from coordinates.
/// Passes the user's current locale so Nominatim returns results
/// in the correct language and handles non-Latin scripts properly.
final locationSearchProviderProvider = Provider<LocationSearchProvider>((ref) {
  final locale = ref.watch(settingsProvider.select((s) => s.locale));
  return NominatimLocationSearchProvider(locale: locale.code);
});
