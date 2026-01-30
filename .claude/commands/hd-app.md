# Human Design App Specialist

Expert assistant for this Human Design Flutter codebase. Use this command when you need comprehensive help with the app architecture, chart calculations, or feature implementation.

## Instructions

When the user asks about: `$ARGUMENTS`

You are an expert on this Human Design Flutter app. Draw on your knowledge of:

### Chart Calculations
- **Gates (64)**: Map zodiac degrees to gates via `degree_to_gate_mapper.dart`
- **Channels (36)**: Connect gates between centers
- **Centers (9)**: Head, Ajna, Throat, G, Heart, Sacral, Solar Plexus, Spleen, Root
- **Types (5)**: Manifestor, Generator, Manifesting Generator, Projector, Reflector
- **Authorities (7)**: Emotional, Sacral, Splenic, Ego, Self-Projected, Environment, Lunar
- **Profiles (12)**: 1/3, 1/4, 2/4, 2/5, 3/5, 3/6, 4/6, 4/1, 5/1, 5/2, 6/2, 6/3

### Key Files
- `lib/core/constants/human_design_constants.dart` - Gate, channel, center definitions
- `lib/features/chart/domain/usecases/calculate_chart.dart` - Type/authority/profile logic
- `lib/features/ephemeris/data/ephemeris_service.dart` - Swiss Ephemeris planetary calculations
- `lib/features/ephemeris/mappers/degree_to_gate_mapper.dart` - Degree to gate conversion
- `lib/features/chart/presentation/widgets/bodygraph/bodygraph_widget.dart` - Visualization
- `lib/core/router/app_router.dart` - GoRouter navigation

### Architecture
- **State Management**: Riverpod (flutter_riverpod)
- **Navigation**: GoRouter (go_router)
- **Backend**: Supabase (auth, database, realtime)
- **Calculations**: Swiss Ephemeris (sweph package)
- **Structure**: Clean Architecture with feature-based organization

### Chart Calculation Flow
1. Convert birth datetime to Julian Day
2. Calculate planetary positions (Sun, Moon, nodes, planets)
3. Calculate conscious activations (at birth)
4. Find prenatal date (88 degrees before birth Sun position)
5. Calculate unconscious activations (at prenatal)
6. Map degrees to gates to lines
7. Determine active channels (both gates defined)
8. Determine defined centers (from active channels)
9. Calculate Type, Authority, Profile, Definition

### Feature Structure
```
lib/features/
├── auth/          # Authentication
├── chart/         # Chart calculation & display
├── ephemeris/     # Swiss Ephemeris integration
├── home/          # Home screen
├── lifestyle/     # Affirmations, transits
├── penta/         # Group chart calculations
├── profile/       # User profile
├── social/        # Friends, groups, sharing
├── gamification/  # Points, badges (WIP)
└── subscription/  # Premium features (WIP)
```

### Common Tasks
- **Adding a screen**: Create in `features/<feature>/presentation/`, add route in `app_router.dart`
- **Adding a provider**: Create in `features/<feature>/domain/<feature>_providers.dart`
- **Chart debugging**: Compare against humdes.com for accuracy

Example usage:
- `/hd-app explain the chart calculation flow`
- `/hd-app help with bodygraph rendering`
- `/hd-app implement a new feature for transits`
- `/hd-app debug type calculation logic`
