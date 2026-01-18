# API Reference

## Supabase Tables

### profiles
```sql
id, user_id, name, email, avatar_url,
birth_date, birth_time, birth_city, birth_country,
birth_lat, birth_lng, timezone,
created_at, updated_at
```

### charts
```sql
id, user_id, name, birth_datetime, birth_location,
type, authority, profile, definition,
defined_centers, active_channels, activations,
created_at
```

## Environment Variables

```
SUPABASE_URL=your-project-url
SUPABASE_ANON_KEY=your-anon-key
```

Config: `lib/core/config/supabase_config.dart`

## Swiss Ephemeris

- Package: `sweph`
- Data files: `assets/ephe/sepl_18.se1`, `semo_18.se1`
- Initialize: `EphemerisService.instance.initialize()`

## Key Services

| Service | File | Purpose |
|---------|------|---------|
| EphemerisService | `ephemeris/data/` | Planetary calculations |
| TransitService | `lifestyle/domain/` | Daily transits |
| AffirmationService | `lifestyle/domain/` | Daily affirmations |
| AuthRepository | `auth/data/` | Supabase auth |
| ProfileRepository | `profile/data/` | User profiles |
