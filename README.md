# Human Design App

A comprehensive Flutter mobile application for Human Design chart generation, learning, and social interaction.

## Features

### Core Features
- **Personal Chart Generation** - Calculate your Human Design chart using Swiss Ephemeris
- **Interactive Bodygraph** - Visual representation of 9 centers, 36 channels, and 64 gates
  - Full channels displayed when both gates are active
  - Hanging gates (half-lines) for single-gate activations
  - Color-coded: black (conscious), red (unconscious), striped (both)
  - Pinch-to-zoom and pan gestures for detailed viewing
  - Zoom controls (+/-) for precise adjustment
- **6-Tab Chart View** - Bodygraph, Planets, Properties, Gates, Channels, Chakras
- **Saved Charts** - Create and manage charts for family, friends, and clients
- **Profile Management** - Customize your profile with avatar upload and birth data editing
- **Transit Tracking** - Current planetary transits and their impact on your chart
- **Daily Affirmations** - Personalized affirmations based on your design

### Social Platform
- **3-Tab Social Screen** - Thoughts, Discover, Groups
- **Thoughts Feed** - Share insights, reflections, transit observations, and achievements
- **Following System** - Twitter-style one-way following (replaced mutual friends system)
- **Discovery & Matching** - Find users by HD type, profile, authority with compatibility scoring
- **User Profiles** - Privacy badges, clickable followers/following lists, thoughts section
- **Comments System** - Reply to comments, like comments, delete own comments, nested replies
- **Stories** - 24-hour ephemeral content with HD color themes
- **Direct Messaging** - Real-time conversations with chart/transit sharing
- **Groups** - Build your HD community with group sharing

### Learning & Quizzes
- **Quiz System** - 138+ factual Human Design questions across 7 categories
- **19 Pre-defined Quizzes** - Types, Centers, Authorities, Profiles, Definitions, Gates, Channels
- **Progress Tracking** - Track your learning journey and quiz scores
- **Content Library** - Articles, guides, and educational materials
  - Bookmark content for later reading
  - Like and share content with others
- **Mentorship Program** - Connect with HD practitioners
  - Set up mentor or mentee profile
  - Define expertise areas and experience
  - Request mentorship from verified mentors

### Gamification
- **Points & Levels** - Earn points for engagement and level up
- **Badges** - Unlock achievements across Social, Learning, Engagement, and Transit categories
- **Daily Challenges** - Type-specific and transit-based challenges
- **Leaderboards** - Weekly, monthly, and all-time rankings

### Advanced Analysis
- **Composite Charts** - Relationship compatibility analysis
- **Penta Analysis** - Small group (2-5 people) dynamics for couples and teams
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

The app calculates accurate Human Design charts verified against reference sites (humdes.com).

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

### Calculation Details

- **Swiss Ephemeris** - High-precision planetary positions
- **58° HD Wheel Offset** - Proper alignment with the Human Design mandala (Gate 41 at 2° Aquarius)
- **Timezone Support** - Birth time stored and displayed in local timezone
- **88° Prenatal** - Binary search algorithm for accurate Design calculation

### Planetary Bodies Tracked
Sun, Earth, Moon, North Node, South Node, Mercury, Venus, Mars, Jupiter, Saturn, Uranus, Neptune, Pluto

## Documentation

- [Architecture](docs/ARCHITECTURE.md) - System design and patterns
- [API Reference](docs/API.md) - Provider and repository documentation
- [Changelog](docs/CHANGELOG.md) - Version history and updates
- [Development Guide](docs/DEVELOPMENT.md) - Setup and contribution guidelines
- [Standards](docs/STANDARDS.md) - Code style and conventions
- [Test Users](docs/TEST_USERS.md) - Test accounts for social feature development

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

## Testing

### Test Accounts

For testing social features, use these pre-configured test accounts:

| Account | Email | Password |
|---------|-------|----------|
| Main | `test@humandesign.app` | *(your password)* |
| Alice (Manifestor) | `alice@test.hd` | `TestPass123` |
| Bob (Generator) | `bob@test.hd` | `TestPass123` |
| Carol (MG) | `carol@test.hd` | `TestPass123` |
| David (Projector) | `david@test.hd` | `TestPass123` |
| Emma (Reflector) | `emma@test.hd` | `TestPass123` |

See [Test Users](docs/TEST_USERS.md) for complete documentation including pre-configured friendships, follows, and posts.

## License

This project is proprietary software.
