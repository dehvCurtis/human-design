# Auth Login Issue

**Date:** 2026-01-17
**Status:** Open
**Priority:** High

## Issue

Users are encountering an error when attempting to log in via the authentication screens.

## Current Workaround

Auth bypass has been enabled for development:

```dart
// lib/features/auth/domain/auth_providers.dart:9
const bool kBypassAuth = true;
```

**Remember to set this back to `false` before production release.**

## Investigation Needed

1. **Capture the exact error message** - What error is displayed to the user?
2. **Check Supabase configuration**:
   - Verify `SUPABASE_URL` and `SUPABASE_ANON_KEY` are correct
   - Check Supabase dashboard for auth logs
   - Verify email/password auth is enabled in Supabase Auth settings
3. **Check OAuth providers** (if using Apple/Google sign-in):
   - Verify OAuth credentials are configured in Supabase
   - Check redirect URLs match app configuration
   - Verify iOS deep linking is working for OAuth callbacks
4. **Check network connectivity**:
   - Ensure simulator has internet access
   - Check if Supabase endpoint is reachable

## Files to Review

| File | Purpose |
|------|---------|
| `lib/features/auth/data/auth_repository.dart` | Auth methods (signIn, signUp, OAuth) |
| `lib/features/auth/domain/auth_providers.dart` | Auth state management |
| `lib/core/config/supabase_config.dart` | Supabase credentials |
| `ios/Runner/Info.plist` | OAuth redirect URL schemes |

## Potential Fixes

- [ ] Verify Supabase credentials in config
- [ ] Enable email auth in Supabase dashboard
- [ ] Configure OAuth providers properly
- [ ] Check RLS policies aren't blocking auth
- [ ] Test with fresh Supabase project if needed

## Resolution

_To be filled when issue is resolved._
