import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/widgets/forms/location_search_field.dart';
import '../data/nominatim_location_service.dart';

/// Provider for the location search service
///
/// Uses Nominatim (OpenStreetMap) for worldwide city search with
/// automatic timezone detection from coordinates.
final locationSearchProviderProvider = Provider<LocationSearchProvider>((ref) {
  return NominatimLocationSearchProvider();
});
