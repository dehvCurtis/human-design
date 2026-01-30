# Run App

Run the Human Design Flutter app.

## Instructions

Run the Flutter app with appropriate options based on `$ARGUMENTS`:

### No arguments - Run on default device
```bash
flutter run
```

### With device specification
```bash
flutter run -d <device>
```

### Common device options:
- `ios` - iOS Simulator
- `android` - Android Emulator
- `chrome` - Chrome browser
- `macos` - macOS desktop

### With hot reload watching
The app will automatically hot reload on file changes.

### Debug steps if run fails:
1. Check `flutter doctor` for environment issues
2. Ensure Supabase is configured (check .env file)
3. Ensure ephemeris files exist in assets/ephe/
4. Check iOS/Android simulator is running

Example usage:
- `/run-app` - Run on default device
- `/run-app ios` - Run on iOS simulator
- `/run-app chrome` - Run in Chrome browser
