# AuraMap Pre-Launch Checklist

## Subscription & Payments

- [ ] Create Apple Developer account (if not done)
- [ ] Create Google Play Developer account ($25 fee, if not done)
- [ ] **App Store Connect**: Create subscription group "AuraMap Premium"
  - [ ] Add product `premium_monthly` — $9.99/month
  - [ ] Add product `premium_yearly` — $79.99/year
- [ ] **Google Play Console**: Create matching subscriptions
  - [ ] Add product `premium_monthly` — $9.99/month
  - [ ] Add product `premium_yearly` — $79.99/year
- [ ] **RevenueCat Dashboard** (app.revenuecat.com):
  - [ ] Create project
  - [ ] Add Apple app + connect App Store Connect
  - [ ] Add Google app + connect Play Console
  - [ ] Create products: `premium_monthly`, `premium_yearly`
  - [ ] Create entitlement: `premium`
  - [ ] Create offering with monthly and yearly packages
  - [ ] Copy API keys to `.env`:
    - [ ] `REVENUECAT_APPLE_API_KEY`
    - [ ] `REVENUECAT_GOOGLE_API_KEY`
- [ ] Test purchases in sandbox (iOS)
- [ ] Test purchases in test mode (Android)
- [ ] Verify premium status syncs to Supabase `profiles.is_premium`
- [ ] Verify restore purchases flow works
- [ ] Verify free tier limits enforce correctly (3 shares, 0 groups, 5 AI messages)

## AI Chat

- [ ] Choose AI provider: Gemini (default), Claude, or OpenAI
- [ ] Set API key in Supabase Edge Function secrets:
  - Gemini: `GEMINI_API_KEY`
  - Claude: `ANTHROPIC_API_KEY`
  - OpenAI: `OPENAI_API_KEY`
- [ ] Set `AI_PROVIDER` env var on Edge Function (default: `gemini`)
- [ ] Deploy Edge Function: `supabase functions deploy ai-chat`
- [ ] Test AI chat with a known chart
- [ ] Verify free user quota (5 messages/month) enforces correctly
- [ ] Verify premium users get unlimited messages
- [ ] Verify 429 response when quota exceeded

## Firebase / Push Notifications

- [ ] Run `flutterfire configure` from project root
- [ ] Verify `firebase_options.dart` is generated
- [ ] Test push notifications on physical device (iOS)
- [ ] Test push notifications on physical device (Android)
- [ ] Verify topic subscriptions work (transits, affirmations, challenges)

## Legal & Compliance

- [x] Privacy Policy created
- [x] Terms of Service created
- [x] GitHub Pages repo pushed (auramap)
- [ ] Enable GitHub Pages on auramap repo (Settings > Pages > main branch)
- [ ] Verify legal pages are live at `https://<username>.github.io/auramap/`
- [ ] Add privacy policy URL to App Store Connect
- [ ] Add privacy policy URL to Google Play Console
- [ ] Complete App Store Privacy questionnaire
- [ ] Complete Google Play Data Safety form

## App Store Connect (iOS)

- [ ] Create app in App Store Connect
- [ ] App name: AuraMap
- [ ] Set primary category (Lifestyle or Entertainment)
- [ ] Write app description and keywords
- [ ] Upload app icon (1024x1024)
- [ ] Take screenshots for required device sizes:
  - [ ] iPhone 6.7" (iPhone 15 Pro Max)
  - [ ] iPhone 6.1" (iPhone 15 Pro)
  - [ ] iPad Pro 12.9"
- [ ] Add privacy policy URL
- [ ] Add support URL
- [ ] Set age rating
- [ ] Set pricing (free with IAP)
- [ ] Build and upload: `flutter build ios` + Xcode archive
- [ ] Submit for review

## Google Play Console (Android)

- [ ] Create app in Play Console
- [ ] Write store listing (description, short description)
- [ ] Upload app icon and feature graphic
- [ ] Take screenshots for phone and tablet
- [ ] Complete Data Safety form
- [ ] Add privacy policy URL
- [ ] Set content rating
- [ ] Set pricing (free with IAP)
- [ ] Build and upload: `flutter build appbundle`
- [ ] Submit for review

## Testing Before Submission

- [ ] Test on physical iOS device
- [ ] Test on physical Android device
- [ ] Verify chart accuracy against humdes.com with known birth data
- [ ] Test all auth flows (email, Apple, Google sign-in)
- [ ] Test subscription purchase and restore
- [ ] Test AI chat with free and premium accounts
- [ ] Test push notifications
- [ ] Test social features (posts, messages, stories)
- [ ] Test chart sharing (free limit + premium unlimited)
- [ ] Test account deletion (GDPR cascade)
- [ ] Test data export
- [ ] Run `flutter test` — all tests pass
- [ ] Test all 3 locales (EN, RU, UK)

## Post-Submission

- [ ] Update auramap README with App Store and Play Store links
- [ ] Update download badge links in README
- [ ] Set up RevenueCat webhooks for server-side events (optional)
- [ ] Monitor crash reports
- [ ] Monitor user feedback and reviews
