# Changelog

All notable changes to this project will be documented in this file.

## [Unreleased]

### Added
- **Language Selection on First Launch** - Users can choose English, Russian, or Ukrainian on the onboarding screen
- **Chart Management for Others** - New screen to create and save Human Design charts for other people
  - New route `/charts/add` with full birth data entry form
  - Charts saved to Supabase with user association
  - Rename and delete functionality for saved charts
- **Full Localization** - All UI strings now support EN/RU/UK localization
  - Home screen widgets (affirmation, transits, quick actions, chart preview)
  - Auth screens (sign in, sign up, birth data)
  - Penta analysis screen
  - Saved charts screen

### Fixed
- **Affirmation Card Overflow** - Action buttons now wrap to prevent overflow on smaller screens or with longer translations
- **Type Safety Issues** - Fixed dynamic type usage in chart_screen.dart and profile_screen.dart

### Changed
- Onboarding screen now shows language selector before welcome content
- Saved charts FAB now navigates to new chart entry screen
- Chart providers now fetch saved charts from Supabase database

## [0.1.0] - 2026-01-17

### Added
- Initial app implementation
- Human Design chart calculation using Swiss Ephemeris
- Bodygraph visualization widget
- User authentication (Email, Apple, Google via Supabase)
- Profile management with birth data
- Daily affirmations based on chart type
- Transit tracking with personal impact
- Social features (friends, groups, sharing)
- Penta (group dynamics) analysis
- Multi-language support infrastructure (EN/RU/UK)
- Dark/Light/System theme support
