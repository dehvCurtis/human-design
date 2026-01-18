import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_colors.dart';

/// A date picker field widget
class DatePickerField extends StatelessWidget {
  const DatePickerField({
    super.key,
    required this.value,
    required this.onChanged,
    this.label,
    this.hint = 'Select date',
    this.firstDate,
    this.lastDate,
    this.enabled = true,
    this.errorText,
    this.helperText,
    this.dateFormat,
  });

  final DateTime? value;
  final void Function(DateTime) onChanged;
  final String? label;
  final String hint;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final bool enabled;
  final String? errorText;
  final String? helperText;
  final DateFormat? dateFormat;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final formatter = dateFormat ?? DateFormat.yMMMMd();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: theme.textTheme.titleSmall?.copyWith(
              color: isDark
                  ? AppColors.textSecondaryDark
                  : AppColors.textSecondaryLight,
            ),
          ),
          const SizedBox(height: 8),
        ],
        InkWell(
          onTap: enabled ? () => _showDatePicker(context) : null,
          borderRadius: BorderRadius.circular(12),
          child: InputDecorator(
            decoration: InputDecoration(
              hintText: hint,
              errorText: errorText,
              helperText: helperText,
              prefixIcon: const Icon(Icons.calendar_today_outlined),
              suffixIcon: const Icon(Icons.arrow_drop_down),
              enabled: enabled,
            ),
            child: Text(
              value != null ? formatter.format(value!) : hint,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: value != null
                    ? null
                    : (isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondaryLight),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _showDatePicker(BuildContext context) async {
    final now = DateTime.now();
    final first = firstDate ?? DateTime(1900);
    final last = lastDate ?? now;

    final picked = await showDatePicker(
      context: context,
      initialDate: value ?? DateTime(1990, 1, 1),
      firstDate: first,
      lastDate: last,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: AppColors.primary,
                ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      onChanged(picked);
    }
  }
}

/// Birth date picker with appropriate defaults
class BirthDatePickerField extends StatelessWidget {
  const BirthDatePickerField({
    super.key,
    required this.value,
    required this.onChanged,
    this.label = 'Birth Date',
    this.hint = 'Select your birth date',
    this.enabled = true,
    this.errorText,
  });

  final DateTime? value;
  final void Function(DateTime) onChanged;
  final String? label;
  final String hint;
  final bool enabled;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    return DatePickerField(
      value: value,
      onChanged: onChanged,
      label: label,
      hint: hint,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      enabled: enabled,
      errorText: errorText,
    );
  }
}
