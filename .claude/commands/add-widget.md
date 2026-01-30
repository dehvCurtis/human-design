# Add New Widget

Create a new reusable widget for the Human Design app.

## Instructions

When the user provides: `$ARGUMENTS`

Parse to determine:
1. Widget location (shared/widgets/ or features/<feature>/presentation/widgets/)
2. Widget name
3. Widget type (Stateless, Stateful, Consumer)

Follow these templates:

### StatelessWidget
```dart
import 'package:flutter/material.dart';

class <WidgetName> extends StatelessWidget {
  const <WidgetName>({
    super.key,
    // Add required parameters
  });

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
```

### StatefulWidget
```dart
import 'package:flutter/material.dart';

class <WidgetName> extends StatefulWidget {
  const <WidgetName>({
    super.key,
  });

  @override
  State<<WidgetName>> createState() => _<WidgetName>State();
}

class _<WidgetName>State extends State<<WidgetName>> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
```

### ConsumerWidget (with Riverpod)
```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class <WidgetName> extends ConsumerWidget {
  const <WidgetName>({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container();
  }
}
```

Guidelines:
- Use `const` constructors where possible
- Add appropriate documentation
- Follow the existing design system (AppColors, AppTheme)
- Make widgets configurable with parameters

Example usage:
- `/add-widget shared/cards/info_card` - Creates InfoCard in shared widgets
- `/add-widget chart/widgets/gate_card Consumer` - Creates GateCard with Riverpod
