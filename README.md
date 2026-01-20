# Human Design App

A comprehensive Flutter mobile application for Human Design chart generation, learning, and social interaction.

## Features

### Core Features
- **Personal Chart Generation** - Calculate your Human Design chart using Swiss Ephemeris
- **Interactive Bodygraph** - Visual representation of 9 centers, 36 channels, and 64 gates
- **6-Tab Chart View** - Bodygraph, Planets, Properties, Gates, Channels, Chakras
- **Saved Charts** - Create and manage charts for family, friends, and clients
- **Transit Tracking** - Current planetary transits and their impact on your chart
- **Daily Affirmations** - Personalized affirmations based on your design

### Social Platform
- **Discovery & Matching** - Find users by HD type, profile, authority with compatibility scoring
- **Content Feed** - Share insights, reflections, transit observations, and achievements
- **Stories** - 24-hour ephemeral content with HD color themes
- **Direct Messaging** - Real-time conversations with chart/transit sharing
- **Friends & Groups** - Build your HD community

### Learning & Quizzes
- **Quiz System** - 138+ factual Human Design questions across 7 categories
- **19 Pre-defined Quizzes** - Types, Centers, Authorities, Profiles, Definitions, Gates, Channels
- **Progress Tracking** - Track your learning journey and quiz scores
- **Content Library** - Articles, guides, and educational materials

### Gamification
- **Points & Levels** - Earn points for engagement and level up
- **Badges** - Unlock achievements across Social, Learning, Engagement, and Transit categories
- **Daily Challenges** - Type-specific and transit-based challenges
- **Leaderboards** - Weekly, monthly, and all-time rankings

### Advanced Analysis
- **Composite Charts** - Relationship compatibility analysis
- **Penta Analysis** - Small group (3-5 people) dynamics
- **HD Compatibility Scoring** - Type, profile, channel, and center compatibility

### Premium Features
- **Subscription Tiers** - Free, Plus, and Pro plans
- **Extended Sharing** - Unlimited chart exports and shares
- **Advanced Reports** - Detailed compatibility and transit reports

## Tech Stack

| Component | Technology |
|-----------|------------|
| Framework | Flutter 3.x (Dart) |
| State Management | Riverpod |
| Backend | Supabase (Auth, Database, Realtime) |
| Chart Calculations | Swiss Ephemeris (sweph) |
| Navigation | GoRouter |
| Subscriptions | RevenueCat |
| Push Notifications | Firebase Cloud Messaging |
| Localization | EN, RU, UK |

## Getting Started

### Prerequisites

- Flutter SDK ^3.8.0
- Xcode (for iOS development)
- Android Studio (for Android development)
- Supabase project (for backend)

### Installation

1. Clone the repository:
```bash
git clone https://github.com/dehvCurtis/human-design.git
cd human-design
```

2. Install dependencies:
```bash
flutter pub get
```

3. Configure Supabase:
   - Create a Supabase project
   - Run migrations from `supabase/migrations/`
   - Update `lib/core/config/app_config.dart` with your credentials

4. Generate localizations:
```bash
flutter gen-l10n
```

5. Run the app:
```bash
flutter run
```

## Project Structure

```
lib/
├── core/
│   ├── config/           # App configuration
│   ├── constants/        # Human Design data (gates, channels, centers)
│   ├── router/           # GoRouter navigation
│   └── theme/            # Design system (colors, typography)
├── features/
│   ├── auth/             # Authentication (email, Apple, Google)
│   ├── chart/            # Chart calculation & bodygraph display
│   ├── composite/        # Relationship charts
│   ├── discovery/        # User discovery & matching
│   ├── ephemeris/        # Swiss Ephemeris integration
│   ├── feed/             # Content feed & posts
│   ├── gamification/     # Points, badges, challenges, leaderboards
│   ├── home/             # Home screen & dashboard
│   ├── learning/         # Content library & mentorship
│   ├── lifestyle/        # Affirmations & transits
│   ├── messaging/        # Direct messages
│   ├── notifications/    # Push notifications (FCM)
│   ├── penta/            # Group dynamics analysis
│   ├── profile/          # User profile management
│   ├── quiz/             # Quiz system & question generators
│   ├── settings/         # App settings & preferences
│   ├── sharing/          # Chart export & sharing
│   ├── social/           # Friends & groups
│   ├── stories/          # 24h ephemeral content
│   ├── subscription/     # Premium features (RevenueCat)
│   └── transits/         # Transit tracking
├── l10n/                 # Localization (EN, RU, UK)
└── shared/
    ├── providers/        # Supabase client provider
    └── widgets/          # Reusable UI components
```

## Human Design Calculations

The app calculates:

| Component | Description |
|-----------|-------------|
| **Conscious (Personality)** | Planetary positions at birth |
| **Unconscious (Design)** | Planetary positions ~88° before birth Sun |
| **Type** | Generator, Projector, Manifestor, Reflector, Manifesting Generator |
| **Authority** | Sacral, Emotional, Splenic, Ego, Self-Projected, Environment, Lunar |
| **Profile** | 12 combinations (1/3, 1/4, 2/4, 2/5, 3/5, 3/6, 4/6, 4/1, 5/1, 5/2, 6/2, 6/3) |
| **Definition** | Single, Split, Triple Split, Quadruple Split, No Definition |
| **Centers** | 9 energy centers (defined/undefined) |
| **Channels** | 36 channels connecting centers |
| **Gates** | 64 gates mapped from I Ching hexagrams |

### Planetary Bodies Tracked
Sun, Earth, Moon, North Node, South Node, Mercury, Venus, Mars, Jupiter, Saturn, Uranus, Neptune, Pluto

## Documentation

- [Architecture](docs/ARCHITECTURE.md) - System design and patterns
- [API Reference](docs/API.md) - Provider and repository documentation
- [Changelog](docs/CHANGELOG.md) - Version history and updates
- [Development Guide](docs/DEVELOPMENT.md) - Setup and contribution guidelines
- [Standards](docs/STANDARDS.md) - Code style and conventions

## Key Commands

```bash
# Run the app
flutter run

# Run tests
flutter test

# Analyze code
flutter analyze

# Generate localizations
flutter gen-l10n

# Build for iOS
flutter build ios

# Build for Android
flutter build apk
```

## License

This project is proprietary software.
