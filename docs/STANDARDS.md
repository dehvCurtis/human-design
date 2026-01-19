# Development Standards

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
