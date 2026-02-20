# Auth Method Configuration

## Overview

Configure authentication methods and email confirmation settings for the Human Design app.

## Current Auth Methods

| Method | Flow | Email Confirmation |
|--------|------|-------------------|
| Apple Sign-In | Native (sign_in_with_apple) | Not required (Apple verifies) |
| Google Sign-In | OAuth (external browser + PKCE) | Not required (Google verifies) |
| Email/Password | Direct Supabase auth | Required by default |

## Supabase Configuration

### Email Confirmation Setting

To disable email confirmation for email/password signups:

1. Go to [Supabase Dashboard](https://supabase.com/dashboard)
2. Select your project
3. Navigate to **Authentication** → **Providers** → **Email**
4. Toggle off **"Confirm email"**
5. Save changes

### OAuth Provider Setup

#### Apple Sign-In (Native)
- Uses `sign_in_with_apple` package for native iOS Sign in with Apple sheet
- ID token is passed directly to Supabase via `signInWithIdToken`
- No browser redirect needed — better UX and no deep link issues
- Supabase Dashboard: Authentication → Providers → Apple
  - Set **Client IDs** to your iOS bundle ID (e.g., `com.insideme.humandesign`)
  - Secret Key is **not required** for native sign-in
- iOS entitlements configured in `ios/Runner/Runner.entitlements`
- Uses a cryptographic nonce (SHA-256 hashed) for security

#### Google Sign-In (OAuth)
- Uses Supabase OAuth with PKCE flow via external browser
- Launches in external Safari (`LaunchMode.externalApplication`)
- Redirects back to app via `io.humandesign.app://auth/callback` URL scheme
- Supabase Dashboard: Authentication → Providers → Google
  - Required: Client ID, Client Secret (from Google Cloud Console)
- Supabase Dashboard: Authentication → URL Configuration
  - Add `io.humandesign.app://auth/callback` to Redirect URLs
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

## Dependencies

| Package | Purpose |
|---------|---------|
| `supabase_flutter` | OAuth flow, session management, `signInWithIdToken` |
| `sign_in_with_apple` | Native Apple Sign-In sheet on iOS |
| `crypto` | SHA-256 nonce hashing for Apple Sign-In |
| `url_launcher` | External browser launch for Google OAuth |

## Environment Variables

The app uses Supabase credentials loaded from `.env` via `flutter_dotenv`:

```bash
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_ANON_KEY=your-anon-key
```
