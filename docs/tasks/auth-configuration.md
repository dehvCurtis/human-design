# Auth Method Configuration

## Overview

Configure authentication methods and email confirmation settings for the Human Design app.

## Current Auth Methods

| Method | Status | Email Confirmation |
|--------|--------|-------------------|
| Apple Sign-In | Enabled | Not required (Apple verifies) |
| Google Sign-In | Enabled | Not required (Google verifies) |
| Email/Password | Enabled | Required by default |

## Supabase Configuration

### Email Confirmation Setting

To disable email confirmation for email/password signups:

1. Go to [Supabase Dashboard](https://supabase.com/dashboard)
2. Select your project
3. Navigate to **Authentication** → **Providers** → **Email**
4. Toggle off **"Confirm email"**
5. Save changes

### OAuth Provider Setup

#### Apple Sign-In
- Requires Apple Developer account
- Configure in Supabase: Authentication → Providers → Apple
- Required: Service ID, Team ID, Key ID, Private Key
- iOS entitlements configured in `ios/Runner/Runner.entitlements`

#### Google Sign-In
- Requires Google Cloud Console project
- Configure in Supabase: Authentication → Providers → Google
- Required: Client ID, Client Secret
- iOS URL schemes configured in `ios/Runner/Info.plist`

## Files Related to Auth

| File | Purpose |
|------|---------|
| `lib/features/auth/data/auth_repository.dart` | Auth API calls |
| `lib/features/auth/domain/auth_providers.dart` | Riverpod providers |
| `lib/features/auth/domain/auth_errors.dart` | Error handling |
| `lib/features/auth/presentation/sign_in_screen.dart` | Login UI |
| `lib/features/auth/presentation/sign_up_screen.dart` | Registration UI |
| `lib/features/auth/presentation/birth_data_screen.dart` | Birth data entry |
| `ios/Runner/Info.plist` | iOS OAuth URL schemes |
| `ios/Runner/Runner.entitlements` | iOS Sign in with Apple |

## Task Checklist

- [ ] Verify Apple Sign-In is working in production
- [ ] Verify Google Sign-In is working in production
- [ ] Decide on email confirmation policy (enable/disable)
- [ ] Configure password reset email templates in Supabase
- [ ] Set up custom email templates (optional)
- [ ] Test auth flow on iOS device
- [ ] Test auth flow on Android device (if applicable)

## Security Considerations

1. **Email Confirmation** - Enabling prevents fake email signups
2. **OAuth Preferred** - OAuth is more secure than email/password
3. **Rate Limiting** - Supabase has built-in rate limiting for auth
4. **Password Requirements** - Configure minimum password strength in Supabase

## Environment Variables

The app uses these Supabase credentials (passed via `--dart-define`):

```bash
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_ANON_KEY=your-anon-key
```

These are configured in the build command and accessed via `String.fromEnvironment()`.
