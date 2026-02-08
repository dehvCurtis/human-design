# Security Audit Report

**Date:** February 7, 2026
**Scope:** Full codebase (Flutter client, Supabase backend, Edge Functions)
**Overall Grade:** B- (Good foundation with critical gaps)

---

## Summary

| Severity | Count |
|----------|-------|
| CRITICAL | 7 |
| HIGH | 8 |
| MEDIUM | 10 |
| LOW | 5 |

---

## CRITICAL Issues

### 1. Service Role Key & DB Password bundled in client app
**File:** `.env` (lines 4, 7)
**Issue:** `SUPABASE_SERVICE_ROLE_KEY` and `SUPABASE_DB_PASSWORD` are in the `.env` file which gets bundled into the compiled app via `pubspec.yaml` assets. Anyone who decompiles the APK/IPA can extract admin credentials that bypass all RLS.
**Fix:** Remove both from `.env` immediately. These should ONLY exist as Supabase Edge Function environment variables, never in client code.

### 2. Generic increment/decrement SQL functions bypass RLS
**File:** `supabase/migrations/004_utility_functions.sql` (lines 5-34)
**Issue:** `SECURITY DEFINER` functions with `GRANT EXECUTE TO authenticated` allow any authenticated user to call `increment('profiles', <uuid>, 'points', 999999)` or modify ANY table column, bypassing RLS.
**Fix:** Add whitelist validation for allowed table/column combinations, or replace with table-specific functions.

### 3. Premium share limit only enforced client-side
**File:** `lib/features/sharing/data/sharing_repository.dart`
**Issue:** Free users' 3-share-per-month limit is checked only in Dart code. Users can bypass by calling Supabase directly.
**Fix:** Add RLS policy or Edge Function that enforces the limit server-side.

### 4. Premium status potentially self-grantable
**File:** `lib/features/profile/data/profile_repository.dart` (line 228)
**Issue:** `updatePremiumStatus` updates `is_premium` on profiles table. If UPDATE policy allows users to modify their own row without column restrictions, users can grant themselves premium.
**Fix:** Add RLS `WITH CHECK` that prevents users from modifying `is_premium` field, or use a trigger/function that only allows service role to change it.

### 5. Supabase credentials in committed documentation
**File:** `docs/STANDARDS.md` (lines 88-89)
**Issue:** Real Supabase URL and anon key committed in git history as an "example."
**Fix:** Replace with placeholders. Consider rotating anon key if repo is shared.

### 6. Supabase temp files tracked in git
**Files:** `supabase/.temp/project-ref`, `supabase/.temp/pooler-url`
**Issue:** Database connection string and project reference committed to git.
**Fix:** Add `supabase/.temp/` to `.gitignore` and remove from git.

### 7. Missing INSERT policies on gamification tables
**File:** `supabase/migrations/003_rls_policies.sql`
**Issue:** `user_challenges`, `user_badges`, and `point_transactions` lack INSERT policies. Comment says "handled by system" but no service role policies exist.
**Fix:** Add explicit INSERT policies for service role operations.

---

## HIGH Issues

### 8. Search query SQL wildcard injection
**File:** `lib/features/discovery/data/discovery_repository.dart` (line 324, 406)
**Issue:** User search input directly interpolated into `.ilike()` patterns without escaping `%` and `_` wildcards.
**Fix:** Escape SQL wildcards before interpolation:
```dart
String _escapeLikePattern(String input) {
  return input.replaceAll('\\', '\\\\').replaceAll('%', '\\%').replaceAll('_', '\\_');
}
```

### 9. Supabase auth tokens stored unencrypted
**Issue:** Supabase Flutter SDK stores auth tokens in SharedPreferences (plain text) by default.
**Fix:** Implement `SecureLocalStorage` wrapper using `flutter_secure_storage` package.

### 10. Missing WITH CHECK on UPDATE policies
**File:** `supabase/migrations/001_initial_schema.sql`, `003_rls_policies.sql`
**Issue:** Multiple tables (`profiles`, `groups`, `comments`, etc.) have UPDATE policies with `USING` but no `WITH CHECK` clause. Users could potentially change ownership fields during updates.
**Fix:** Add `WITH CHECK (auth.uid() = user_id)` to all UPDATE policies.

### 11. Overly permissive leaderboard access
**File:** `supabase/migrations/003_rls_policies.sql` (line 260)
**Issue:** `user_points` table has `USING (TRUE)` SELECT policy exposing all user point data.
**Fix:** Create a view with only public leaderboard fields and restrict full table access.

### 12. Gemini API key in URL query string
**File:** `supabase/functions/ai-chat/index.ts` (line 50)
**Issue:** API key passed as URL parameter `?key=` which may appear in server logs.
**Fix:** Use `x-goog-api-key` header instead.

### 13. No rate limiting on Edge Function
**File:** `supabase/functions/ai-chat/index.ts`
**Issue:** No per-user request rate limiting. Only monthly quota exists.
**Fix:** Implement per-user rate limiting (e.g., max 10 requests per minute).

### 14. Broad FOR ALL policies on multiple tables
**File:** `supabase/migrations/001_initial_schema.sql`
**Issue:** `saved_affirmations`, `journal_entries`, `pentas`, `content_progress` use single `FOR ALL` policies missing `WITH CHECK` for INSERT.
**Fix:** Split into separate SELECT/INSERT/UPDATE/DELETE policies with proper checks.

### 15. Missing file size validation on uploads
**File:** `lib/features/profile/data/profile_repository.dart` (line 251)
**Issue:** Avatar upload has no file size check. Users could upload arbitrarily large files.
**Fix:** Add max file size check (e.g., 5MB) before upload.

---

## MEDIUM Issues

### 16. Missing `maxLength` on UI TextFields
**Files:** `create_post_sheet.dart`, `edit_profile_screen.dart`
**Issue:** Post content TextField has no `maxLength` property. Backend rejects but UX is poor.
**Fix:** Add `maxLength` matching backend limits (posts: 5000, comments: 2000, messages: 2000).

### 17. No client-side share generation throttling
**File:** `lib/features/sharing/data/sharing_repository.dart`
**Issue:** No cooldown on share link creation.
**Fix:** Add client-side debounce (e.g., 1 per 5 seconds).

### 18. Chart context size not validated in Edge Function
**File:** `supabase/functions/ai-chat/index.ts` (line 329)
**Issue:** `chart_context` accepted without size validation. Comment says "already sanitized by client."
**Fix:** Add server-side size limit (e.g., 10KB).

### 19. Error responses may leak stack traces in Edge Function logs
**File:** `supabase/functions/ai-chat/index.ts` (line 523)
**Issue:** Full error object logged which could contain API keys or SQL details.
**Fix:** Sanitize error objects before logging.

### 20. Activities INSERT policy allows any activity type
**File:** `supabase/migrations/20260122000003_activity_feed.sql` (line 104)
**Issue:** Users could create fake achievement activities.
**Fix:** Restrict activity types that authenticated users can create.

### 21. Missing DELETE policies on several tables
**Files:** Various migrations
**Issue:** `poll_votes`, `expert_reviews`, `user_challenges` lack DELETE policies.
**Fix:** Add DELETE policies for user-owned records.

### 22. Quiz question mappings publicly visible
**File:** `supabase/migrations/005_quiz_system.sql` (line 327)
**Issue:** `USING (TRUE)` on `quiz_question_map` lets users predetermine quiz questions.
**Fix:** Restrict based on active quiz attempts.

### 23. String interpolation in Supabase queries
**File:** `lib/features/feed/data/feed_repository.dart` (line 53, 732)
**Issue:** `.or()` and `.ilike()` calls use string interpolation bypassing parameterization.
**Fix:** Use Supabase's filter builder methods where possible.

### 24. No debouncing on expensive search queries
**Files:** Discovery, learning screens
**Issue:** Each keystroke triggers a Supabase query.
**Fix:** Add debounce (300-500ms) on search input fields.

### 25. FCM token logged on error
**File:** `lib/features/notifications/data/notification_service.dart` (line 111)
**Issue:** Error message may contain FCM token.
**Fix:** Remove `$e` from debug print or sanitize.

---

## LOW Issues

### 26-30. Minor policy and UX issues
- `friendships` UPDATE policy only checks `friend_id`, not `user_id` (can't cancel own request)
- `shares` missing UPDATE policy (can't extend expiration)
- `comments` UPDATE missing WITH CHECK
- `learning_path_steps` uses single FOR ALL instead of granular policies
- Profile name field has no length limit in UI

---

## Passing Categories

- ✅ **XSS Prevention**: No HTML rendering, WebView, or eval() found
- ✅ **Pagination**: All list queries use `.limit()` or `.range()`
- ✅ **Auth Guards**: Router properly redirects unauthenticated users
- ✅ **OAuth CSRF Protection**: State parameter validation implemented
- ✅ **SSRF Prevention**: URL validator with whitelist, private IP blocking
- ✅ **No hardcoded secrets in Dart source code**
- ✅ **`.env` properly gitignored** (not in git history)
- ✅ **Firebase config files properly gitignored**
- ✅ **AI quota enforcement**: Server-side in Edge Function
- ✅ **UUID validation**: Proper format checks before queries
- ✅ **All 74 tables have RLS enabled**
- ✅ **198 RLS policies defined**
- ✅ **Edge Function JWT validation**: Proper auth checks

---

## Priority Action Plan

### Immediate (before app store submission)
1. Remove `SUPABASE_SERVICE_ROLE_KEY` and `SUPABASE_DB_PASSWORD` from `.env`
2. Fix generic increment/decrement functions (whitelist or remove)
3. Add server-side share limit enforcement
4. Prevent `is_premium` self-modification via RLS
5. Clean up `docs/STANDARDS.md` and `supabase/.temp/` from git

### High Priority (next sprint)
6. Escape search query wildcards
7. Implement secure token storage
8. Add WITH CHECK to all UPDATE policies
9. Move Gemini API key to header
10. Add file size validation on uploads

### Medium Priority (before v1.1)
11. Add `maxLength` to all TextFields
12. Implement Edge Function rate limiting
13. Validate chart_context size server-side
14. Add debouncing on search inputs
15. Fix remaining missing DELETE policies
