# Security Audit

Run a security review of the Human Design app codebase, checking for common vulnerabilities in the Supabase + Flutter stack.

## Instructions

When the user specifies scope (optional): `$ARGUMENTS`

If arguments specify particular files or features, focus the audit there. Otherwise, audit the full codebase.

### Checklist

Run through each category below. For each finding, report:
- **Severity**: CRITICAL / HIGH / MEDIUM / LOW
- **Location**: File path and line number
- **Issue**: What's wrong
- **Fix**: How to fix it

---

#### 1. API Key & Secret Exposure

Search the codebase for hardcoded secrets:
- Search for patterns: `supabase_url`, `supabase_anon_key`, `service_role`, `api_key`, `secret`, `password`, `token` in Dart files
- Check `lib/core/config/app_config.dart` — anon key is OK (public), service role key must NEVER appear in client code
- Check `.env` files are in `.gitignore`
- Check no secrets in ARB localization files or constants

#### 2. Supabase RLS Policies

Read all migration files in `supabase/migrations/`:
- Every `CREATE TABLE` must be followed by `ALTER TABLE ... ENABLE ROW LEVEL SECURITY`
- Every table with user data must have policies using `auth.uid() = user_id`
- SELECT policies must use `USING` clause
- INSERT policies must use `WITH CHECK` clause
- UPDATE policies must use both `USING` and `WITH CHECK`
- No tables should be left without any policies (full public access)

#### 3. Edge Function Security

Read all files in `supabase/functions/`:
- JWT validation present (checks `Authorization` header, calls `auth.getUser()`)
- Input validation for all user-provided fields (length limits, type checks, UUID format)
- Service role key accessed only via `Deno.env.get()`, never hardcoded
- Error responses don't leak internal details (stack traces, SQL errors)
- CORS headers present on all responses including errors

#### 4. Client-Side Input Validation

Search Dart files for Supabase queries:
- `.from(` calls should use parameterized queries (Supabase client handles this, but verify no string interpolation in `.rpc()` calls)
- User input used in queries should be validated (UUID format, string length)
- No raw SQL construction in client code

#### 5. Content & Storage Limits

Check for abuse prevention:
- Text input fields have `maxLength` or equivalent limits
- File upload sizes are limited
- Rate limiting on expensive operations (AI chat, share generation)
- Pagination on list queries (`.limit()` or `.range()`)

#### 6. XSS Prevention

Search for dangerous patterns:
- No `Html` widget or raw HTML rendering of user content
- No `javascript:` URLs
- No `eval()` or equivalent dynamic code execution
- User-generated content displayed as plain text, not HTML

#### 7. Premium/Quota Enforcement

Check that premium features are enforced server-side:
- Read subscription-related Edge Functions
- Verify quota checks happen in Edge Functions, not just client-side
- Check that free-tier limits can't be bypassed by calling Supabase directly

#### 8. Authentication Checks

Review navigation guards:
- Read `lib/core/router/app_router.dart` for redirect logic
- Verify authenticated routes redirect unauthenticated users
- Check that auth state changes trigger proper navigation

---

### Output Format

```
Security Audit Report
=====================
Date: <today>
Scope: <full codebase or specified scope>

CRITICAL Issues: <count>
HIGH Issues: <count>
MEDIUM Issues: <count>
LOW Issues: <count>

---

[CRITICAL] <title>
File: <path>:<line>
Issue: <description>
Fix: <recommendation>

[HIGH] <title>
...

---

Summary: <1-2 sentence overall assessment>
```

If no issues are found in a category, note it as passing:
```
✓ RLS Policies: All tables have RLS enabled with correct policies
```
