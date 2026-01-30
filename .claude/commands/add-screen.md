# Add New Screen

Create a new screen in the Human Design app following clean architecture patterns.

## Instructions

When the user provides: `$ARGUMENTS`

1. Parse the feature name and screen name from the arguments (format: `feature/screen_name`)
2. Create the screen file at `lib/features/<feature>/presentation/<screen_name>_screen.dart`
3. Follow this template structure:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';

class <ScreenName>Screen extends ConsumerStatefulWidget {
  const <ScreenName>Screen({super.key});

  @override
  ConsumerState<<ScreenName>Screen> createState() => _<ScreenName>ScreenState();
}

class _<ScreenName>ScreenState extends ConsumerState<<ScreenName>Screen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('<Screen Title>'),
      ),
      body: const Center(
        child: Text('TODO: Implement <ScreenName>Screen'),
      ),
    );
  }
}
```

4. Add a route for the screen in `lib/core/router/app_router.dart`
5. If needed, create a provider file at `lib/features/<feature>/domain/<feature>_providers.dart`
6. Report what was created and what manual steps remain (like adding imports)

Example usage:
- `/add-screen profile/edit_profile` - Creates EditProfileScreen in profile feature
- `/add-screen chart/gate_detail` - Creates GateDetailScreen in chart feature
