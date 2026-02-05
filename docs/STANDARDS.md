# Development Standards

## Semantic Versioning

This project follows [Semantic Versioning 2.0.0](https://semver.org/) for version management.

### Version Format

```
MAJOR.MINOR.PATCH+BUILD
```

| Component | Description | When to Increment |
|-----------|-------------|-------------------|
| **MAJOR** | Breaking changes | API changes, major UI overhauls, database migrations requiring data loss |
| **MINOR** | New features | New screens, features, backward-compatible additions |
| **PATCH** | Bug fixes | Bug fixes, performance improvements, minor tweaks |
| **BUILD** | Build number | Every release to App Store/Play Store (must always increment) |

### Pre-release Versions (0.x.x)

While the major version is `0`, the app is in active development:
- `0.1.0` - Initial implementation
- `0.2.0` - Social platform, gamification, quiz system
- `0.x.x` - Continued feature development
- `1.0.0` - First stable public release

### Version History

| Version | Build | Description |
|---------|-------|-------------|
| 0.1.0 | 1 | Initial app with chart calculation, bodygraph |
| 0.2.0 | 2 | Social platform, gamification, quiz, sharing |
| 0.2.1 | 3 | Integration channel layout fix, Heart/Ego adjustments |
| 0.2.2 | 4 | Sun gate quick access, transit keynotes |
| 0.2.3 | 5 | Critical HD wheel offset fix, timezone display |
| 0.2.4 | 6 | Hanging gates (half-channel) visualization |
| 0.2.5 | 7 | Bodygraph zoom/pan, Ego center circle, auth fixes |
| 0.2.6 | - | Heart center position, Gate 10 direction fix |
| 0.2.7 | - | Avatar upload, mentorship setup, bookmarks/likes |
| 0.2.8 | 8 | More tab, Daily rename, Penta 2+, quiz answer fix |

### Updating the Version

1. Update `version` in `pubspec.yaml`
2. Update `docs/CHANGELOG.md` with changes
3. For releases, always increment the build number (`+N`)

### Examples

```yaml
# Bug fix release
version: 0.2.1+3

# New feature release
version: 0.3.0+4

# Breaking change / major release
version: 1.0.0+5
```

### Git Tags

Create git tags for releases:
```bash
git tag -a v0.2.0 -m "Version 0.2.0 - Social platform and gamification"
git push origin v0.2.0
```

---

## Running the App

### Required Environment Variables

The app requires Supabase credentials to be passed at compile time using `--dart-define` flags. The credentials are stored in `.env` but must be explicitly passed to Flutter:

```bash
flutter run -d <device> \
  --dart-define=SUPABASE_URL=<your-supabase-url> \
  --dart-define=SUPABASE_ANON_KEY=<your-supabase-anon-key>
```

### Example (using values from .env)

```bash
flutter run -d ios \
  --dart-define=SUPABASE_URL=https://uqngxpvcmwkcrvnyatvp.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

### Why `--dart-define`?

The app uses `String.fromEnvironment()` in `lib/core/config/app_config.dart` which reads compile-time constants. This approach:

1. Keeps secrets out of the compiled binary when not provided
2. Allows different configurations for debug/release builds
3. Follows Flutter's recommended pattern for environment configuration

### Quick Reference

| Variable | Description |
|----------|-------------|
| `SUPABASE_URL` | Your Supabase project URL |
| `SUPABASE_ANON_KEY` | Supabase anonymous/public key |
| `REVENUECAT_APPLE_API_KEY` | (Optional) RevenueCat iOS key |
| `REVENUECAT_GOOGLE_API_KEY` | (Optional) RevenueCat Android key |

---

## Design Standards

### Color Palette

The app uses a **purple/violet color scheme** consistent with the style guide. Colors are defined in `lib/core/theme/app_colors.dart`.

#### Primary Colors

| Name | Hex | Usage |
|------|-----|-------|
| Primary | `#6366F1` | Buttons, links, accents |
| Primary Light | `#818CF8` | Hover states, backgrounds |
| Primary Dark | `#4F46E5` | Active states |
| Secondary | `#8B5CF6` | Secondary actions |
| Secondary Light | `#A78BFA` | Light accents |
| Secondary Dark | `#7C3AED` | Borders, emphasis |

#### Bodygraph Colors

| Element | Color | Hex |
|---------|-------|-----|
| Defined Centers (fill) | Light purple | `#DDD6FE` |
| Defined Centers (border) | Dark purple | `#7C3AED` |
| Undefined Centers (fill) | White | `#FFFFFF` |
| Undefined Centers (border) | Light purple | `#C4B5FD` |
| Conscious Activations | Dark indigo | `#3730A3` |
| Unconscious Activations | Pink/magenta | `#DB2777` |
| Both Activations | Violet | `#7C3AED` |
| Inactive Elements | Light purple tint | `#E9D5FF` |
| Transit Overlay | Cyan | `#0891B2` |

#### Differentiation Guidelines

1. **Conscious vs Unconscious**: Use contrasting colors (indigo vs pink) for clear visual distinction
2. **Defined vs Undefined**: Use filled purple for defined, white for undefined
3. **Active vs Inactive**: Use saturated colors for active, light tints for inactive
4. **Transits**: Use cyan to stand out from the base purple chart

---

## Bodygraph Layout Standards

### Layout File
All bodygraph positions are defined in `lib/features/chart/presentation/widgets/bodygraph/bodygraph_layout_standard.dart`.

### Canvas Dimensions
- **Canvas size**: 400x600 pixels
- **Center positions**: Defined as (x, y) coordinates with width/height

### Center Positions

| Center | Position (x, y) | Size (w × h) | Shape |
|--------|-----------------|--------------|-------|
| Head | (200, 48) | 70 × 60 | Triangle (up) |
| Ajna | (200, 125) | 70 × 60 | Triangle (down) |
| Throat | (200, 210) | 60 × 60 | Square |
| G | (200, 310) | 84 × 70 | Heart |
| Heart/Ego | (255, 345) | 41 × 32 | Triangle (up) |
| Spleen | (90, 400) | 56 × 65 | Triangle (right) |
| Sacral | (200, 430) | 60 × 60 | Square |
| Solar Plexus | (310, 400) | 56 × 65 | Triangle (left) |
| Root | (200, 545) | 60 × 60 | Square |

### Integration Channels (10-20-34-57)

The Integration channels form a distinctive pattern with a diagonal backbone:

```
        20 (Throat)
         \
          \ J1 ← Gate 10 connects here (140, 265)
           \
            \ J2 ← Gate 34 connects here (105, 330)
             \
              57 (Spleen)
```

| Channel | Path Description |
|---------|------------------|
| 20-57 | Direct diagonal backbone from Throat to Spleen |
| 10-20 | Gate 10 → J1 → Gate 20 |
| 10-34 | Gate 10 → J1 → J2 → Gate 34 |
| 10-57 | Gate 10 → J1 → Gate 57 |
| 20-34 | Gate 20 → J2 → Gate 34 |
| 34-57 | Gate 34 → J2 → Gate 57 |

### Heart/Ego Gate Positions

| Gate | Position | Connection |
|------|----------|------------|
| 51 | Left side middle (245, 345) | To Gate 25 (G) |
| 21 | Right side middle (266, 345) | To Gate 45 (Throat) |
| 26 | Bottom left corner (235, 361) | To Gate 44 (Spleen) |
| 40 | Bottom right corner (276, 361) | To Gate 37 (Solar Plexus) |

### Custom Channel Paths

Channels that require waypoints (non-straight lines) are defined in `_customChannelPaths`. These include:
- Throat ↔ Spleen channels (route around G center)
- Integration channels (share junction points)
- Heart ↔ other center channels

---

## Quiz System

### Question Generator Structure

Quiz questions are generated dynamically by category-specific generators in `lib/features/quiz/data/question_generators/`.

| Generator | Questions | Categories Covered |
|-----------|-----------|-------------------|
| `types_questions.dart` | 25+ | Strategies, auras, population stats |
| `centers_questions.dart` | 26+ | Functions, biological correlations |
| `authorities_questions.dart` | 17+ | 7 authorities, hierarchy |
| `profiles_questions.dart` | 26+ | 12 profiles, 6 lines |
| `definitions_questions.dart` | 14+ | 5 definition types |
| `gates_questions.dart` | Dynamic | Gate-center mapping, keynotes |
| `channels_questions.dart` | Dynamic | Gate pairs, circuit types |

### Adding New Questions

1. Open the appropriate generator file
2. Add questions to `_generateBeginnerQuestions()`, `_generateIntermediateQuestions()`, or `_generateAdvancedQuestions()`
3. Use helper methods: `createMultipleChoice()` or `createTrueFalse()`
4. Include clear explanations for educational value

Example:
```dart
questions.add(createMultipleChoice(
  category: QuizCategory.types,
  difficulty: QuizDifficulty.beginner,
  questionText: 'What is the Generator\'s strategy?',
  correctAnswer: 'To Respond',
  wrongAnswers: ['To Initiate', 'Wait for Invitation', 'Wait 28 days'],
  explanation: 'Generators have sustainable energy and are designed to respond to life...',
));
```
