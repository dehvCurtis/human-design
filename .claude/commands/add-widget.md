# Add New Widget

Create a Flutter widget following the app's theme system and composition patterns.

## Instructions

When the user provides: `$ARGUMENTS`

Parse to determine:
1. Widget location (shared/widgets/ or features/<feature>/presentation/widgets/)
2. Widget name
3. Widget type (Stateless, Stateful, Consumer)
4. Widget purpose/description

### Step 1: Read theme and existing patterns

Before writing, read these files to match the design system:
- `lib/core/theme/app_colors.dart` — color tokens (light/dark)
- `lib/core/theme/app_theme.dart` — text styles, spacing, shapes

Then read existing widgets in the same location to match patterns:
- For shared widgets: `lib/shared/widgets/`
- For feature widgets: `lib/features/<feature>/presentation/widgets/`

Note the conventions: naming, parameter style, theme usage, const usage.

### Step 2: Create the widget

Place at the correct path:
- Shared: `lib/shared/widgets/<widget_name>.dart`
- Feature: `lib/features/<feature>/presentation/widgets/<widget_name>.dart`

#### StatelessWidget (no state, no providers)
```dart
import 'package:flutter/material.dart';

/// Brief description of what this widget displays.
class <WidgetName> extends StatelessWidget {
  const <WidgetName>({
    super.key,
    required this.param,
  });

  final Type param;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.extension<AppColorsExtension>();

    return Container();
  }
}
```

#### StatefulWidget (local state, animations)
```dart
import 'package:flutter/material.dart';

/// Brief description of what this widget does.
class <WidgetName> extends StatefulWidget {
  const <WidgetName>({
    super.key,
    required this.param,
  });

  final Type param;

  @override
  State<<WidgetName>> createState() => _<WidgetName>State();
}

class _<WidgetName>State extends State<<WidgetName>> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container();
  }
}
```

#### ConsumerWidget (needs Riverpod providers)
```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Brief description of what this widget displays.
class <WidgetName> extends ConsumerWidget {
  const <WidgetName>({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Container();
  }
}
```

### Step 3: Apply design patterns

Follow these rules based on what was found in the existing code:

- **Use `const`** constructors and `const` child widgets wherever possible
- **Theme colors**: Use `Theme.of(context)` for colors, never hardcode color values
- **Dark/light mode**: Both must work — use theme colors, not fixed colors
- **Text styles**: Use `theme.textTheme.bodyMedium` etc., don't create ad-hoc styles
- **Spacing**: Use consistent values (8, 12, 16, 24) matching existing patterns
- **Border radius**: Match existing patterns (typically `BorderRadius.circular(12)` or `BorderRadius.circular(16)`)
- **Parameters**: Make the widget configurable — accept callbacks (`onTap`, `onChanged`), display data via parameters, use optional parameters with defaults for customization
- **Accessibility**: Add `Semantics` widget for non-obvious interactive elements

### Step 4: Handle common widget types

**Card widget**: Use `Card` or styled `Container` with box decoration, padding, and rounded corners.

**List item**: Use `ListTile` or custom `Row` with leading icon, title/subtitle, trailing action.

**Bottom sheet**: Use `showModalBottomSheet` with `DraggableScrollableSheet` for scrollable content.

**Form field**: Wrap `TextFormField` with label, validation, error display.

**Empty state**: Center with icon, title text, subtitle text, and optional action button.

### Step 5: Add documentation comment

Add a brief `///` doc comment on the class explaining what it displays and when to use it.

Example usage:
- `/add-widget shared/cards/info_card Stateless card with icon, title, subtitle`
- `/add-widget chart/widgets/gate_card Consumer card showing gate details from provider`
- `/add-widget events/widgets/event_tile Stateless list tile for event items`
- `/add-widget home/widgets/daily_transit_card Consumer card showing today's transits`
