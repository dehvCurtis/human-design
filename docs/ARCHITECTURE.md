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
│   ├── discovery/        # User discovery & matching
│   ├── ephemeris/        # Swiss Ephemeris integration
│   ├── feed/             # Content feed & posts
│   ├── gamification/     # Points, badges, challenges
│   ├── home/             # Home screen & providers
│   ├── ai_assistant/      # AI chat, transit insights, chart reading, compatibility, dream, journal
│   ├── dream_journal/    # Dream journal & journaling entries
│   ├── learning/         # Content library & mentorship
│   ├── lifestyle/        # Transits & affirmations
│   ├── messaging/        # Direct messages
│   ├── profile/          # User profile
│   ├── settings/         # App settings
│   ├── sharing/          # Chart export & sharing
│   ├── social/           # Following & groups
│   ├── stories/          # 24h ephemeral content
│   └── subscription/     # Premium features & message packs
└── shared/
    ├── providers/        # Supabase client
    └── widgets/          # Reusable UI components
```

## Feature Module Structure

Each feature follows Clean Architecture:

```
feature/
├── data/
│   └── {feature}_repository.dart    # Data access layer
├── domain/
│   ├── models/                       # Domain models
│   └── {feature}_providers.dart      # Riverpod providers
└── presentation/
    ├── {feature}_screen.dart         # Main screen
    └── widgets/                      # Feature-specific widgets
```

## State Management

- **Riverpod** for all state management
- Providers in `domain/` folders per feature
- `ConsumerWidget` / `ConsumerStatefulWidget` for UI

### Provider Types

| Type | Use Case |
|------|----------|
| `Provider` | Computed/derived values, singletons |
| `FutureProvider` | Async data fetching |
| `FutureProvider.family` | Parameterized async data |
| `StreamProvider` | Realtime subscriptions |
| `NotifierProvider` | Complex mutable state |
| `StateProvider` | Simple mutable state |

## Navigation

- **GoRouter** with declarative routing
- Auth redirect logic in `app_router.dart`
- Routes defined in `AppRoutes` class
- Deep linking configured for iOS

## Data Flow

```
UI (Widget) → Provider → Repository/Service → Supabase/Ephemeris
```

## Key Providers

### Core Providers

| Provider | Type | Purpose |
|----------|------|---------|
| `authStatusProvider` | Provider | Current auth state |
| `userChartProvider` | FutureProvider | User's HD chart |
| `todayTransitsProvider` | Provider | Current transits |
| `settingsProvider` | NotifierProvider | App settings |

### Social Platform Providers

| Provider | Type | Purpose |
|----------|------|---------|
| `discoveryUsersProvider` | FutureProvider.family | User discovery with filters |
| `feedProvider` | FutureProvider | Content feed posts |
| `feedNotifierProvider` | NotifierProvider | Feed mutations |
| `followingStoriesProvider` | FutureProvider | Stories from followed users |
| `conversationsProvider` | FutureProvider | DM conversations |
| `userPointsProvider` | FutureProvider | Gamification points |
| `badgesProvider` | FutureProvider | Available badges |
| `challengesProvider` | FutureProvider | Active challenges |
| `contentLibraryProvider` | FutureProvider.family | Learning content |
| `sharingNotifierProvider` | NotifierProvider | Sharing operations |

### AI Assistant Providers

| Provider | Type | Purpose |
|----------|------|---------|
| `aiRepositoryProvider` | Provider | AI repository singleton |
| `aiUsageProvider` | FutureProvider | Usage quota tracking |
| `canUseAiProvider` | FutureProvider | Client-side quota check |
| `aiChatNotifierProvider` | NotifierProvider | Active chat session state |
| `aiConversationsProvider` | FutureProvider | Conversation list |
| `aiMessagesProvider` | FutureProvider.family | Messages per conversation |
| `suggestedQuestionsProvider` | Provider.family | Chart-based question suggestions |
| `transitInsightProvider` | FutureProvider | Today's AI transit insight |
| `chartReadingProvider` | FutureProvider.autoDispose | AI chart reading generation |
| `journalingPromptsProvider` | FutureProvider | Today's AI journaling prompts |

### Dream Journal Providers

| Provider | Type | Purpose |
|----------|------|---------|
| `dreamRepositoryProvider` | Provider | DreamRepository singleton |
| `dreamEntriesProvider` | FutureProvider | Dream entries list |
| `journalEntriesProvider` | FutureProvider | Journal entries list |
| `journalEntryProvider` | FutureProvider.family | Single journal entry by ID |

## Security

### Row Level Security (RLS)

All Supabase tables use RLS policies:

- **Posts**: Public/followers-only/private visibility
- **DMs**: Only participants can read/write
- **Stories**: Auto-expire after 24h
- **Gamification**: Users can only modify their own data
- **Premium content**: Restricted to subscribers

### iOS Deep Linking

- URL Scheme: `io.humandesign.app://`
- Universal Links: `humandesign.app`
- OAuth callback handling configured

## Database Schema

### Core Tables
- `profiles` - User profiles with HD data
- `charts` - Saved charts

### Social Platform Tables
- `user_follows` - Follow relationships
- `posts` - Feed content
- `reactions` - Post reactions (HD-specific types)
- `stories` - 24h ephemeral content
- `story_views` - Story view tracking
- `conversations` - DM threads
- `direct_messages` - Individual messages
- `shares` - Shared content links

### Gamification Tables
- `user_points` - Points & levels
- `point_transactions` - Point history
- `badges` - Badge definitions
- `user_badges` - Earned badges
- `challenges` - Challenge definitions
- `user_challenges` - Challenge progress

### AI Tables
- `ai_conversations` - AI chat conversations per user
- `ai_messages` - Individual messages (user + assistant)
- `ai_usage` - Monthly message count tracking per user
- `ai_purchases` - Message pack purchase audit trail

### Journal Tables
- `journal_entries` - Dream journal and journaling entries (entry_type: dream/journal)

### Learning Tables
- `content_library` - Articles, guides, quizzes
- `content_progress` - User progress tracking
- `mentorship_profiles` - Mentor/mentee profiles
- `mentorship_requests` - Mentorship connections
- `live_sessions` - Scheduled sessions
- `session_participants` - Session registrations

## Human Design Specifics

### HD Compatibility Scoring

The matching service calculates compatibility across 4 dimensions:

1. **Type Compatibility** (0-25 pts) - Energy type dynamics
2. **Profile Harmonics** (0-25 pts) - Line resonance
3. **Channel Interactions** (0-25 pts) - Electromagnetic connections
4. **Center Bridging** (0-25 pts) - Definition complementarity

### HD-Specific Reactions

Posts support Human Design themed reactions:
- `generator_sacral` - Satisfaction
- `projector_recognition` - "I see you"
- `manifestor_peace` - Alignment
- `reflector_surprise` - Delight
- `mg_satisfaction` - MG satisfaction

### Post Types

- `insight` - Personal HD insights
- `reflection` - Daily reflections
- `transit_share` - Transit observations
- `chart_share` - Chart element sharing
- `question` - Community questions
- `achievement` - Badge announcements
