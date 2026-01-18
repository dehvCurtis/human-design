# Architecture

## Project Structure

```
lib/
├── core/
│   ├── config/           # Environment config
│   ├── constants/        # HD data (gates, channels, centers)
│   ├── router/           # GoRouter navigation
│   └── theme/            # Design system
├── features/
│   ├── auth/             # Authentication (Supabase)
│   ├── chart/            # Chart calculation & bodygraph
│   ├── ephemeris/        # Swiss Ephemeris integration
│   ├── home/             # Home screen & providers
│   ├── lifestyle/        # Transits & affirmations
│   ├── profile/          # User profile
│   ├── settings/         # App settings
│   └── social/           # Friends & groups
└── shared/
    ├── providers/        # Supabase client
    └── widgets/          # Reusable UI components
```

## State Management

- **Riverpod** for all state management
- Providers in `domain/` folders per feature
- `ConsumerWidget` / `ConsumerStatefulWidget` for UI

## Navigation

- **GoRouter** with declarative routing
- Auth redirect logic in `app_router.dart`
- Routes defined in `AppRoutes` class

## Data Flow

```
UI (Widget) → Provider → Repository/Service → Supabase/Ephemeris
```

## Key Providers

| Provider | Type | Purpose |
|----------|------|---------|
| `authStatusProvider` | Provider | Current auth state |
| `userChartProvider` | FutureProvider | User's HD chart |
| `todayTransitsProvider` | Provider | Current transits |
| `settingsProvider` | NotifierProvider | App settings |
