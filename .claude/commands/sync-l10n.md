# Sync Localization

Keep all 3 ARB localization files (EN, RU, UK) in sync — find missing keys and generate translations.

## Instructions

When the user provides context (optional): `$ARGUMENTS`

### Step 1: Read all ARB files

Read these files:
- `lib/l10n/app_en.arb` (source of truth)
- `lib/l10n/app_ru.arb`
- `lib/l10n/app_uk.arb`

### Step 2: Find missing keys

Compare `app_en.arb` against `app_ru.arb` and `app_uk.arb`:
- Identify keys present in EN but missing from RU
- Identify keys present in EN but missing from UK
- Identify keys present in RU or UK but NOT in EN (orphaned — flag for removal)
- Ignore metadata keys (keys starting with `@`)

### Step 3: Report findings

Output a summary:
```
Localization Sync Report
========================
EN keys: <count>
RU keys: <count> (missing: <count>)
UK keys: <count> (missing: <count>)

Missing from RU:
- key_name: "English value"
- key_name2: "English value"

Missing from UK:
- key_name: "English value"

Orphaned keys (not in EN):
- old_key (in RU)
```

### Step 4: Generate translations

For each missing key, add the translated value to the appropriate ARB file:
- **Russian (RU)**: Provide accurate Russian translation
- **Ukrainian (UK)**: Provide accurate Ukrainian translation

Follow the naming convention: `feature_descriptiveName`
- Examples: `home_welcomeMessage`, `chart_gateDetail`, `settings_darkMode`

Place new keys in the same position/section as they appear in `app_en.arb` to keep files aligned.

### Step 5: Clean up orphaned keys

If any keys exist in RU/UK but not EN, remove them (they're stale).

### Step 6: Verify

Run `flutter gen-l10n` to regenerate the Dart localization files and confirm no errors.

If the arguments mention specific keys or a feature name, focus only on those keys rather than doing a full sync.
