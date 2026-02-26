# Versioning Standard

This project follows [Semantic Versioning 2.0.0](https://semver.org/) with Flutter/mobile conventions.

## Format

```
MAJOR.MINOR.PATCH+BUILD
```

**Example:** `1.2.3+15`

| Segment | Meaning | When to bump |
|---------|---------|--------------|
| **MAJOR** | Breaking changes | Incompatible API changes, major redesigns, data migrations that break backward compatibility |
| **MINOR** | New features | New screens, new functionality, significant UI changes, new language support |
| **PATCH** | Bug fixes & maintenance | Bug fixes, copy changes, performance improvements, dependency updates, security patches |
| **BUILD** | Build number | Every App Store / TestFlight upload (always increments, never resets) |

## Rules

1. **Build number always increments** — Every archive uploaded to App Store Connect must have a unique build number. Never reuse or reset it.
2. **Version can stay the same across builds** — Multiple builds (e.g., `1.2.0+10`, `1.2.0+11`) can share a version while iterating in TestFlight.
3. **Bump version before release** — When submitting to the App Store for public release, ensure the version reflects the changes since the last public release.
4. **Pre-launch versions start at 1.0.0** — The initial App Store release is `1.0.0`.

## Where Version Lives

- **Source of truth:** `pubspec.yaml` line `version: MAJOR.MINOR.PATCH+BUILD`
- Flutter propagates this to both iOS (`CFBundleShortVersionString` + `CFBundleVersion`) and Android (`versionName` + `versionCode`) automatically.
- Do not edit `Info.plist` or `build.gradle` version fields directly.

## Examples

| Change | Before | After |
|--------|--------|-------|
| Fix a crash in chat screen | `1.0.0+1` | `1.0.1+2` |
| Add localization for 8 languages | `1.0.1+2` | `1.1.0+3` |
| Redesign onboarding flow | `1.1.0+3` | `1.1.0+4` (TestFlight) |
| Ship redesign to App Store | `1.1.0+4` | `1.2.0+5` |
| Major v2 rewrite | `1.2.0+5` | `2.0.0+6` |
| Quick hotfix after v2 launch | `2.0.0+6` | `2.0.1+7` |

## Changelog

When bumping the version, add an entry to [docs/CHANGELOG.md](../CHANGELOG.md) with the new version number and a summary of changes.
