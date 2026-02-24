# AI Features Pipeline

This document describes the data flow, context building, and system prompts for each AI-powered feature in the app.

## Architecture Overview

All AI features share the same pipeline:

```
User Action
    |
    v
Provider (quota check + data gathering)
    |
    v
AI Repository (build context, call Edge Function)
    |
    v
Supabase Edge Function (auth, rate limit, store message, call AI)
    |
    v
AI Provider (Claude / Gemini / OpenAI)
    |
    v
Response stored in ai_messages, returned to UI
```

### Key Files

| Layer | File | Purpose |
|-------|------|---------|
| Providers | `lib/features/ai_assistant/domain/ai_providers.dart` | Quota checks, data gathering, state management |
| Repository | `lib/features/ai_assistant/data/ai_repository.dart` | Context building, Edge Function calls |
| Context Builder | `lib/features/ai_assistant/data/chart_context_builder.dart` | Builds sanitized chart/transit JSON |
| Edge Function | `supabase/functions/ai-chat/index.ts` | Auth, rate limiting, system prompts, AI calls |

---

## Context Data Reference

### Chart Context (`buildChartContext`)

Included in **all** AI features:

| Field | Type | Example |
|-------|------|---------|
| `type` | string | `"Generator"` |
| `strategy` | string | `"To Respond"` |
| `authority` | string | `"Sacral"` |
| `profile` | string | `"2/4"` |
| `definition` | string | `"Single"` |
| `defined_centers` | string[] | `["Sacral", "Throat", "G"]` |
| `undefined_centers` | string[] | `["Head", "Ajna", "Heart", "Spleen", "Root", "Solar Plexus"]` |
| `conscious_gates` | object[] | `[{"planet": "sun", "gate": 14, "line": 2, "name": "Possession in Great Measure"}]` |
| `unconscious_gates` | object[] | Same format as conscious |
| `active_channels` | object[] | `[{"id": "34-57", "gate1": 34, "gate2": 57, "has_conscious": true, "has_unconscious": false}]` |
| `incarnation_cross` | object | `{"conscious_sun_gate": 14, "conscious_earth_gate": 8, "unconscious_sun_gate": 59, "unconscious_earth_gate": 55}` |

### Transit Context (`buildTransitContext`)

Extends chart context. Included in **Dream, Journal, Transit Insight, Compatibility**:

| Field | Type | Description |
|-------|------|-------------|
| `today_transits` | object[] | All planetary positions today: `{"planet": "sun", "gate": 41, "line": 3, "name": "Decrease"}` |
| `transit_sun_gate` | int | Today's Sun gate number |
| `transit_earth_gate` | int | Today's Earth gate number |
| `completed_channels` | object[] | Channels where a transit gate completes a personal gate |
| `highlighted_personal_gates` | object[] | Personal gates activated by today's transits |
| `new_gate_activations` | object[] | Gates newly activated by transits (not in natal chart) |

### Compatibility Context (`buildCompatibilityContext`)

Used only for **Compatibility Reading**:

| Field | Type | Description |
|-------|------|-------------|
| `person1` / `person2` | object | Each person's type, strategy, authority, profile, definition, centers, gates |
| `compatibility_score` | number | Overall compatibility percentage |
| `connection_theme` | string | Relationship archetype |
| `electromagnetic_channels` | object[] | Channels where each person has one gate (magnetic attraction) |
| `companionship_channels` | object[] | Channels where both people define the same gate |
| `dominance_channels` | object[] | One person defines both gates |
| `compromise_channels` | object[] | Neither person defines both gates |

### Security

Context building is handled by `ChartContextBuilder` which:
- Only includes enumerated HD data (type, gates, channels, centers)
- Never includes PII (names, birth locations, emails)
- Prevents prompt injection via user-controlled fields
- Truncates context to 4000 characters max

---

## Feature Pipelines

### 1. General Chat

The free-form conversational AI assistant.

| Property | Value |
|----------|-------|
| **Entry** | AI Chat Screen |
| **Provider** | `aiChatNotifierProvider` |
| **Repository** | `sendMessage()` |
| **User Message** | Whatever the user types |
| **Context Type** | `chart` |
| **Context Data** | Chart only (no transits) |
| **Max Tokens** | 1024 |
| **Conversation** | Persistent — messages build on history |
| **Follow-ups** | Yes — full back-and-forth conversation |

**System Prompt**: General HD assistant. Answers questions about the user's chart, explains concepts, references their specific activations.

**Flow**:
1. User types question in chat input
2. `aiChatNotifierProvider.sendMessage()` called with chart context
3. Optimistic UI shows user message immediately
4. Edge Function stores message, loads conversation history (max 20 messages), calls AI
5. AI response stored and returned
6. User can continue the conversation

---

### 2. Transit Insight

Daily personalized interpretation of how transits affect the user's chart.

| Property | Value |
|----------|-------|
| **Entry** | AI Hub Screen / Home Screen card |
| **Provider** | `transitInsightProvider` (autoDispose) |
| **Repository** | `getTransitInsight()` |
| **User Message** | `"Give me my personalized transit insight for today."` (fixed) |
| **Context Type** | `transit_insight` |
| **Context Data** | Chart + Transits + Transit Impact |
| **Max Tokens** | 1024 |
| **Conversation** | Created but not reused |
| **Follow-ups** | No — one-shot generation. "Ask follow-up" opens general chat |

**System Prompt**: Transit analyst. Focuses on Sun gate transit, completed channels, temporarily defined centers. Provides practical advice for the day.

**Flow**:
1. User taps "Transit Insight" on AI Hub
2. `transitInsightProvider` checks quota, gathers chart + transits + impact
3. Sends fixed message with full transit context
4. AI returns 3-5 paragraph personalized insight
5. Displayed as formatted text with "Ask follow-up" button (opens general chat)

---

### 3. Chart Reading

Comprehensive multi-section reading of the user's full chart.

| Property | Value |
|----------|-------|
| **Entry** | AI Hub Screen |
| **Provider** | `chartReadingProvider` (autoDispose) |
| **Repository** | `getChartReading()` |
| **User Message** | `"Generate a comprehensive reading of my Human Design chart."` (fixed) |
| **Context Type** | `chart_reading` |
| **Context Data** | Chart only (no transits) |
| **Max Tokens** | 4096 |
| **Conversation** | Created but not reused |
| **Follow-ups** | No — one-shot generation. "Ask follow-up" opens general chat |

**System Prompt**: Expert analyst with structured output. Generates markdown with headers:
- Type & Strategy
- Inner Authority
- Profile
- Defined Centers
- Key Channels
- Incarnation Cross & Life Purpose

**Flow**:
1. User taps "Chart Reading" on AI Hub
2. Provider checks quota, gets chart
3. Sends fixed message with chart context and `maxTokens: 4096`
4. AI returns 6-8 paragraph structured reading with markdown headers
5. UI parses sections into expandable cards
6. PDF export available via `ChartExportService.exportReadingAsPdf()`

---

### 4. Compatibility Reading

AI analysis of a composite chart between two people.

| Property | Value |
|----------|-------|
| **Entry** | Composite Screen (AppBar button) |
| **Provider** | `compatibilityReadingProvider` |
| **Repository** | `getCompatibilityReading()` |
| **User Message** | `"Analyze the compatibility between these two people."` (fixed) |
| **Context Type** | `compatibility` |
| **Context Data** | Both charts + composite analysis (electromagnetic, companionship, dominance, compromise channels) |
| **Max Tokens** | 2048 |
| **Conversation** | Created but not reused |
| **Follow-ups** | No — one-shot. "Ask follow-up" opens general chat |

**System Prompt**: Relationship analyst. Covers type dynamics, electromagnetic channels, companionship, center bridging, profile harmonics, practical advice. 5-7 paragraphs.

**Flow**:
1. User views composite chart, taps AI button in AppBar
2. Provider builds compatibility context from both charts + `CompositeResult`
3. Sends fixed message with both charts and composite data
4. AI returns balanced relationship analysis
5. Displayed as formatted text

---

### 5. Dream Interpretation

Interprets user-written dream through the HD lens.

| Property | Value |
|----------|-------|
| **Entry** | Dream Journal > Dream Entry Screen > "Interpret with AI" |
| **Provider** | Called directly from screen (not a standalone provider) |
| **Repository** | `interpretDream()` |
| **User Message** | The user's dream text (free-form) |
| **Context Type** | `dream` |
| **Context Data** | Chart + Transits + Transit Impact |
| **Max Tokens** | 1024 |
| **Conversation** | Created but not reused |
| **Follow-ups** | No — one-shot interpretation |

**System Prompt**: Dream interpreter. Explicitly told the user's message IS a dream to interpret. Analyzes dream narrative, identifies symbols, connects to defined/undefined centers, active gates, and transit energies. 2-4 paragraphs.

**Flow**:
1. User writes dream text in Dream Entry Screen
2. Taps "Interpret with AI"
3. `interpretDream()` called with dream text as message + full transit context
4. AI interprets the dream through HD lens
5. Interpretation stored on the `journal_entries` record (`ai_interpretation` column)
6. Displayed below dream text. Can be shared to feed or externally

---

### 6. Journal Prompts

AI-generated personalized journaling prompts for the day.

| Property | Value |
|----------|-------|
| **Entry** | AI Hub Screen |
| **Provider** | `journalingPromptsProvider` (autoDispose) |
| **Repository** | `getJournalingPrompts()` |
| **User Message** | `"Generate personalized journaling prompts for me today."` (fixed) |
| **Context Type** | `journal` |
| **Context Data** | Chart + Transits + Transit Impact |
| **Max Tokens** | 1024 |
| **Conversation** | Created but not reused |
| **Follow-ups** | No — user writes responses to prompts locally |

**System Prompt**: Journaling guide. Generates 3-5 numbered prompts with context notes about which aspect of their design each relates to. Prompts reference Type, Authority, centers, and transit gates.

**Flow**:
1. User taps "Journal Prompts" on AI Hub, then "Generate"
2. `journalingPromptsProvider` checks quota, gathers chart + transits + impact
3. Sends fixed message with full transit context
4. AI returns numbered prompt list
5. UI parses numbered lines into expandable cards
6. Each card has a text field where user writes a response
7. Responses saved as `JournalEntry` records with `entry_type: 'journal'`
8. User can tap refresh to regenerate (costs another message)

---

## Context Data Matrix

| Feature | Chart | Transits | Transit Impact | Composite | User Input | Max Tokens |
|---------|:-----:|:--------:|:--------------:|:---------:|:----------:|:----------:|
| General Chat | Yes | - | - | - | Yes | 1024 |
| Transit Insight | Yes | Yes | Yes | - | Fixed | 1024 |
| Chart Reading | Yes | - | - | - | Fixed | 4096 |
| Compatibility | Yes (x2) | - | - | Yes | Fixed | 2048 |
| Dream Interpret | Yes | Yes | Yes | - | Yes (dream) | 1024 |
| Journal Prompts | Yes | Yes | Yes | - | Fixed | 1024 |

---

## Quota & Rate Limiting

| Tier | Monthly Limit | Rate Limit |
|------|--------------|------------|
| Free | 5 messages/month | 10 requests/minute |
| Premium | Unlimited | 10 requests/minute |

- Each feature invocation counts as 1 message (even fixed-prompt features)
- Usage is pre-incremented before the AI call, decremented on failure
- Rate limiting is DB-backed (`ai_rate_limits` table) with atomic `check_ai_rate_limit` function
- Client checks quota before calling Edge Function (defense-in-depth)
- Bonus messages from purchased packs add to the monthly limit

---

## Edge Function Flow

```
1. Authenticate (JWT validation)
2. Validate inputs (message, context_type, chart_context)
3. Check premium status
4. Check/enforce rate limit (10/min)
5. Create or verify conversation
6. Store user message in ai_messages
7. Load conversation history (max 20 messages)
8. Pre-increment usage (if not premium)
9. Build system prompt (context_type switch + chart JSON)
10. Call AI provider (Claude/Gemini/OpenAI)
11. On failure: decrement usage
12. Store AI response in ai_messages
13. Update conversation metadata (last_message_at, message_count)
14. Return response
```

### AI Provider Selection

Set via `AI_PROVIDER` environment variable on the Edge Function:
- `anthropic` — Claude (default)
- `google` — Gemini
- `openai` — GPT

All providers use the same system prompt + conversation history format.
