# Claude Development Agents & Commands

Custom Claude Code commands and agents to accelerate development of the Human Design app. Each has a specific role and prompt tailored to this codebase.

## Architecture

- **Commands** (`.claude/commands/*.md`): Prompt templates with `$ARGUMENTS` placeholder. Invoked via `/command-name`. Best for template-driven generation where the steps are predictable.
- **Agents** (`.claude/agents/*.md`): YAML frontmatter (name, description, tools, model) + markdown body. Best for multi-step tasks requiring codebase exploration and reasoning.

---

## Commands (12)

### `/add-screen` — HD Screen Scaffolder

**File:** `.claude/commands/add-screen.md`

Generates a complete new screen following Clean Architecture — screen widget, model, repository, providers, router entry, and localization — all wired up.

- Reads existing screens in the same feature to match conventions
- Creates data/domain/presentation layer files as needed
- Adds GoRouter route to `app_router.dart`
- Adds localization keys to all 3 ARB files (EN, RU, UK)
- Runs `flutter gen-l10n` and `flutter analyze` to verify

**Usage:** `/add-screen events/event_detail Event detail page with attendee list`

---

### `/build-migration` — Supabase Migration Builder

**File:** `.claude/commands/build-migration.md`

Generates production-ready SQL migrations with tables, indexes, RLS policies, triggers, and functions — matching the security patterns in `supabase/migrations/20260206_ai_and_community.sql`.

- Creates timestamped migration file in `supabase/migrations/`
- Adds RLS policies (SELECT/INSERT/UPDATE/DELETE) with `auth.uid() = user_id`
- Adds CHECK constraints on text lengths, enum values, numeric ranges
- Creates indexes for common query patterns
- Adds SECURITY DEFINER functions for atomic operations
- Reminds to run `supabase db push`

**Usage:** `/build-migration user_events table with title, description, event_date, location, max_attendees`

---

### `/build-edge-function` — Edge Function Builder

**File:** `.claude/commands/build-edge-function.md`

Scaffolds Supabase Edge Functions (Deno/TypeScript) with JWT auth, input validation, error handling, and CORS — matching the `supabase/functions/ai-chat/index.ts` pattern.

- Creates function directory under `supabase/functions/`
- Adds JWT validation via `supabase.auth.getUser()`
- Adds input sanitization (string length, UUID format, enum whitelisting)
- Adds structured error responses with proper status codes
- Adds CORS headers on all responses
- Reminds to deploy with `supabase functions deploy`

**Usage:** `/build-edge-function event-rsvp that lets users RSVP to events with attendance limits`

---

### `/check-chart` — Chart Calculation Validator

**File:** `.claude/commands/check-chart.md`

Verifies chart calculation accuracy by running tests, tracing the full calculation chain, and cross-referencing against humdes.com.

- Runs existing test suite (`gate_wheel_offset_test.dart`, `timezone_fix_test.dart`) as baseline
- Reads the full calculation chain (ephemeris → mapper → calculate_chart)
- Validates the 58-degree HD wheel offset is applied
- Traces calculation for given birth data through all 12 steps
- Compares Sun/Earth gates, Type, Authority, Profile, Definition, Incarnation Cross
- Outputs structured comparison table

**Usage:** `/check-chart 1985-03-15 14:30 New York`

---

### `/add-provider` — Riverpod Provider Builder

**File:** `.claude/commands/add-provider.md`

Creates properly typed Riverpod providers with correct dependency chains, error handling, and cache invalidation patterns.

- Reads existing providers in the target feature to match conventions
- Supports all types: Provider, FutureProvider, FutureProvider.family, StreamProvider, NotifierProvider, AsyncNotifierProvider
- Family providers with Dart record params for multiple parameters
- Wires up repository dependencies automatically
- Adds invalidation patterns for mutation → refetch flows
- Includes consumer usage example

**Usage:** `/add-provider events/eventDetail FutureProvider.family`

---

### `/sync-l10n` — Localization Sync

**File:** `.claude/commands/sync-l10n.md`

Keeps all 3 ARB localization files (EN, RU, UK) in sync — finds missing keys, generates translations, removes orphaned keys.

- Reads `app_en.arb` as source of truth
- Reports missing keys in `app_ru.arb` and `app_uk.arb`
- Generates Russian and Ukrainian translations for missing keys
- Flags orphaned keys (in RU/UK but not EN) for removal
- Follows `feature_descriptiveName` naming convention
- Runs `flutter gen-l10n` to verify

**Usage:** `/sync-l10n` or `/sync-l10n events feature only`

---

### `/security-audit` — Security Audit

**File:** `.claude/commands/security-audit.md`

Reviews codebase for security vulnerabilities specific to the Supabase + Flutter stack. Runs an 8-category checklist and outputs a structured report with severity levels.

**Checklist:**
1. API key & secret exposure
2. Supabase RLS policies (every table checked)
3. Edge Function security (JWT, input validation, error responses)
4. Client-side input validation
5. Content & storage limits (abuse prevention)
6. XSS prevention (no raw HTML rendering)
7. Premium/quota enforcement (server-side, not just client)
8. Authentication checks (router guards, auth state)

**Usage:** `/security-audit` or `/security-audit supabase/functions/ai-chat/index.ts`

---

### `/add-widget` — Widget Builder

**File:** `.claude/commands/add-widget.md`

Creates Flutter widgets following the app's theme system (`AppColors`, `AppTheme`) and composition patterns.

- Reads `app_colors.dart` and `app_theme.dart` for design tokens first
- Matches existing widget patterns from same feature
- Supports StatelessWidget, StatefulWidget, ConsumerWidget
- Handles dark/light theme via `Theme.of(context)`
- Proper `const` usage and documentation comments
- Covers common types: cards, list items, bottom sheets, form fields, empty states

**Usage:** `/add-widget chart/widgets/gate_card Consumer card showing gate details`

---

### `/write-tests` — Test Writer

**File:** `.claude/commands/write-tests.md`

Generates unit and widget tests following existing test patterns in the codebase.

- Reads source file to understand what to test
- Reads existing test patterns (`gate_wheel_offset_test.dart`, `timezone_fix_test.dart`)
- Creates test file in matching `test/` directory structure
- Unit tests for models/services (serialization, equality, business logic, edge cases)
- Widget tests for screens (pumpWidget, provider overrides, interactions)
- Runs `flutter test` on generated tests to verify they pass

**Usage:** `/write-tests lib/features/events/domain/models/event.dart`

---

### `/run-app` — Run App

**File:** `.claude/commands/run-app.md`

Runs the Flutter app on a specified device with debug steps if it fails.

**Usage:** `/run-app ios` or `/run-app chrome`

---

### `/hd-app` — Human Design App Specialist

**File:** `.claude/commands/hd-app.md`

Expert assistant for the app's architecture, chart calculations, and feature implementation.

**Usage:** `/hd-app explain the chart calculation flow`

---

### `/hd-info` — Human Design Info

**File:** `.claude/commands/hd-info.md`

Provides information about Human Design concepts (gates, centers, types, authorities, profiles).

**Usage:** `/hd-info gate 34` or `/hd-info manifesting generator`

---

## Agents (1)

### `humdes-agent` — HD Domain Expert

**File:** `.claude/agents/humdes-agent.md`
**Model:** Sonnet
**Tools:** Read, Write, Edit, Glob, Grep, Bash

Comprehensive expert assistant for the full codebase. Knows:
- All Human Design domain concepts (64 gates, 36 channels, 9 centers, types, authorities, profiles)
- Chart calculation flow including the 58-degree wheel offset
- Flutter/Riverpod architecture patterns
- Supabase migration and Edge Function patterns
- Security patterns (RLS, JWT, input validation)
- All feature locations (AI assistant, events, discovery, discussions, feed, etc.)

---

## Priority Order

| Priority | Command | Reason |
|----------|---------|--------|
| 1 | `/add-screen` | Most repetitive task, saves the most time per use |
| 2 | `/build-migration` | Error-prone manually, security-critical |
| 3 | `/sync-l10n` | Tedious 3-file sync, easy to miss keys |
| 4 | `/write-tests` | Tests are the most-skipped task, removes friction |
| 5 | `/security-audit` | Run before every PR, catches issues early |
| 6 | `/check-chart` | Critical for correctness, hard to verify manually |
| 7 | `/build-edge-function` | Less frequent but high boilerplate |
| 8 | `/add-provider` | Moderate boilerplate, patterns are learnable |
| 9 | `/add-widget` | Useful but widgets vary too much for full automation |
| 10 | `humdes-agent` | Background expert, enhance over time |
