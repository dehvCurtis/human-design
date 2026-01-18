import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../l10n/generated/app_localizations.dart';

/// Dialog for entering or editing a chart name
class ChartNameDialog extends StatefulWidget {
  const ChartNameDialog({
    super.key,
    this.initialName,
    this.title,
    this.actionLabel,
  });

  final String? initialName;
  final String? title;
  final String? actionLabel;

  /// Shows the dialog and returns the entered name, or null if cancelled
  static Future<String?> show(
    BuildContext context, {
    String? initialName,
    String? title,
    String? actionLabel,
  }) {
    return showDialog<String>(
      context: context,
      builder: (context) => ChartNameDialog(
        initialName: initialName,
        title: title,
        actionLabel: actionLabel,
      ),
    );
  }

  @override
  State<ChartNameDialog> createState() => _ChartNameDialogState();
}

class _ChartNameDialogState extends State<ChartNameDialog> {
  late final TextEditingController _controller;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialName);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return AlertDialog(
      title: Text(widget.title ?? 'Name Your Chart'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Give this chart a name so you can easily find it later.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondaryLight,
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _controller,
              autofocus: true,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(
                labelText: 'Chart Name',
                hintText: 'e.g., John Smith, My Partner',
                prefixIcon: const Icon(Icons.person_outline),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a name';
                }
                if (value.trim().length < 2) {
                  return 'Name must be at least 2 characters';
                }
                return null;
              },
              onFieldSubmitted: (_) => _submit(),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.common_cancel),
        ),
        ElevatedButton(
          onPressed: _submit,
          child: Text(widget.actionLabel ?? l10n.common_save),
        ),
      ],
    );
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      Navigator.pop(context, _controller.text.trim());
    }
  }
}
