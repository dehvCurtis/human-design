# Human Design App

A Flutter mobile application for Human Design chart generation and social interaction.

## Features

- **Personal Chart Generation**: Calculate your Human Design chart using Swiss Ephemeris
- **Interactive Bodygraph**: Visual representation of the 9 centers, 36 channels, and 64 gates
- **Transit Tracking**: See current planetary transits and their impact on your chart
- **Daily Affirmations**: Personalized affirmations based on your design
- **Social Features**: Share charts and connect with others
- **Composite Charts**: Relationship compatibility analysis
- **Penta Analysis**: Small group (3-5 people) dynamics

## Tech Stack

| Component | Technology |
|-----------|------------|
| Frontend | Flutter (Dart) |
| State Management | Riverpod |
| Backend | Supabase (Auth, Database, Realtime) |
| Chart Calculations | Swiss Ephemeris (sweph) |
| Navigation | GoRouter |
| Local Storage | Drift (SQLite) |
| Subscriptions | RevenueCat |

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
   - Update `lib/core/config/app_config.dart` with your credentials

4. Run the app:
```bash
flutter run
```

## Project Structure

```
lib/
├── core/
│   ├── config/           # App configuration
│   ├── constants/        # Human Design data
│   ├── router/           # Navigation
│   └── theme/            # Design system
├── features/
│   ├── auth/             # Authentication
│   ├── chart/            # Chart calculation & display
│   ├── ephemeris/        # Swiss Ephemeris integration
│   ├── home/             # Home screen
│   ├── lifestyle/        # Affirmations & transits
│   ├── penta/            # Group dynamics
│   ├── profile/          # User profile
│   └── social/           # Social features
└── shared/               # Shared providers & widgets
```

## Human Design Calculations

The app calculates:
- **Conscious (Personality)**: Planetary positions at birth
- **Unconscious (Design)**: Planetary positions ~88 days before birth
- **Type**: Generator, Projector, Manifestor, Reflector, Manifesting Generator
- **Authority**: Sacral, Emotional, Splenic, Ego, Self-Projected, Mental, Lunar
- **Profile**: 12 profile combinations (1/3, 1/4, 2/4, etc.)
- **Definition**: Single, Split, Triple Split, Quadruple Split, No Definition

## License

This project is proprietary software.
