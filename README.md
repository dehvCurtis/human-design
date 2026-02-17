# Inside Me: Human Design

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
- **Dream Sharing** - Share dream journal entries with AI interpretations to the feed or externally
- **Following System** - Twitter-style one-way following
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
- **Mentorship Program** - Connect with HD practitioners

### Gamification
- **Points & Levels** - Earn points for engagement and level up
- **Badges** - Unlock achievements across Social, Learning, Engagement, and Transit categories
- **Daily Challenges** - Type-specific and transit-based challenges
- **Leaderboards** - Weekly, monthly, and all-time rankings

### Advanced Analysis
- **Composite Charts** - Relationship compatibility analysis
- **Penta Analysis** - Small group (2-5 people) dynamics for couples and teams
- **HD Compatibility Scoring** - Type, profile, channel, and center compatibility

### AI Assistant
- **Ask AI About Your Chart** - Personalized AI chat powered by Claude, Gemini, or GPT
- **Chart-Aware Responses** - AI receives your chart data for personalized insights
- **Conversation History** - Save and resume AI conversations
- **AI Transit Insights** - Daily personalized interpretation of how transits affect your chart
- **AI Chart Reading** - Comprehensive multi-paragraph chart reading with PDF export
- **AI Compatibility Reading** - AI-powered analysis of composite charts between two people
- **AI Dream Interpretation** - Dream journal with HD-lens AI interpretation using chart + transits
- **AI Journaling Prompts** - Daily personalized journaling prompts based on chart and transits
- **Usage Quota** - Free messages/month, unlimited for premium users

### Premium Features
- **Subscription Tiers** - Free, Monthly, and Yearly plans
- **Extended Sharing** - Unlimited chart exports and shares
- **Advanced Reports** - Detailed compatibility and transit reports
- **Unlimited AI Chat** - No message limits for premium subscribers

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
| AI Chat | Supabase Edge Functions + Claude/Gemini/OpenAI |
| Localization | EN, RU, UK, DE, ES, PT, RO, BE |

## Getting Started

### Prerequisites

- Flutter SDK ^3.8.0
- Xcode (for iOS/macOS development)
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

3. Configure environment:
   - Copy `.env.example` to `.env`
   - Add your Supabase URL and Anon Key
   - Add RevenueCat API keys (optional)

4. Run Supabase migrations:
```bash
supabase db push
```

5. Generate localizations:
```bash
flutter gen-l10n
```

6. Run the app:
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
│   ├── ai_assistant/     # AI chat (Claude/Gemini/OpenAI)
│   ├── chart/            # Chart calculation & bodygraph display
│   ├── composite/        # Relationship charts
│   ├── discovery/        # User discovery & matching
│   ├── dream_journal/    # Dream journal & AI interpretation
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
├── l10n/                 # Localization (EN, RU, UK, DE, ES, PT, RO, BE)
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

## Testing

```bash
# Run all tests (113 passing)
flutter test

# Run specific test suites
flutter test test/calculate_chart_test.dart    # Type, Authority, Definition
flutter test test/gate_wheel_offset_test.dart  # HD wheel offset verification
flutter test test/feed_post_test.dart          # Post model & enums
flutter test test/ai_usage_test.dart           # AI quota & usage
```

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

# Build for macOS
flutter build macos
```

## Links

- [Privacy Policy](https://dehvcurtis.github.io/inside-me-human-design/privacy-policy)
- [Terms of Service](https://dehvcurtis.github.io/inside-me-human-design/terms-of-service)

## License

This project is proprietary software.
