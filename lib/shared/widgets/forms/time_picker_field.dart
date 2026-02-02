import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

/// A time picker field widget
class TimePickerField extends StatefulWidget {
  const TimePickerField({
    super.key,
    required this.value,
    required this.onChanged,
    this.label,
    this.hint = 'Select time',
    this.enabled = true,
    this.errorText,
    this.helperText,
    this.use24HourFormat = false,
    this.showUnknownOption = false,
    this.onUnknownSelected,
    this.isUnknown = false,
  });

  final TimeOfDay? value;
  final void Function(TimeOfDay) onChanged;
  final String? label;
  final String hint;
  final bool enabled;
  final String? errorText;
  final String? helperText;
  final bool use24HourFormat;
  final bool showUnknownOption;
  final VoidCallback? onUnknownSelected;
  final bool isUnknown;

  @override
  State<TimePickerField> createState() => _TimePickerFieldState();
}

class _TimePickerFieldState extends State<TimePickerField> {
  String _formatTime(TimeOfDay time) {
    if (widget.use24HourFormat) {
      final hour = time.hour.toString().padLeft(2, '0');
      final minute = time.minute.toString().padLeft(2, '0');
      return '$hour:$minute';
    } else {
      final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
      final minute = time.minute.toString().padLeft(2, '0');
      final period = time.period == DayPeriod.am ? 'AM' : 'PM';
      return '$hour:$minute $period';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: theme.textTheme.titleSmall?.copyWith(
              color: isDark
                  ? AppColors.textSecondaryDark
                  : AppColors.textSecondaryLight,
            ),
          ),
          const SizedBox(height: 8),
        ],
        InkWell(
          onTap: widget.enabled ? _showTimePicker : null,
          borderRadius: BorderRadius.circular(12),
          child: InputDecorator(
            decoration: InputDecoration(
              hintText: widget.hint,
              errorText: widget.errorText,
              helperText: widget.helperText,
              prefixIcon: const Icon(Icons.access_time_outlined),
              suffixIcon: const Icon(Icons.arrow_drop_down),
              enabled: widget.enabled,
            ),
            child: Text(
              widget.isUnknown
                  ? "I don't know"
                  : (widget.value != null ? _formatTime(widget.value!) : widget.hint),
              style: theme.textTheme.bodyLarge?.copyWith(
                color: (widget.value != null || widget.isUnknown)
                    ? (widget.isUnknown ? AppColors.textSecondaryLight : null)
                    : (isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondaryLight),
                fontStyle: widget.isUnknown ? FontStyle.italic : null,
              ),
            ),
          ),
        ),
        if (widget.showUnknownOption && !widget.isUnknown) ...[
          const SizedBox(height: 8),
          TextButton.icon(
            onPressed: widget.onUnknownSelected,
            icon: const Icon(Icons.help_outline, size: 18),
            label: const Text("I don't know my birth time"),
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              foregroundColor: AppColors.textSecondaryLight,
            ),
          ),
        ],
      ],
    );
  }

  Future<void> _showTimePicker() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: widget.value ?? const TimeOfDay(hour: 12, minute: 0),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: AppColors.primary,
                ),
          ),
          child: MediaQuery(
            data: MediaQuery.of(context).copyWith(
              alwaysUse24HourFormat: widget.use24HourFormat,
            ),
            child: child!,
          ),
        );
      },
    );

    if (picked != null && mounted) {
      widget.onChanged(picked);
    }
  }
}

/// Birth time picker with "I don't know" option
class BirthTimePickerField extends StatelessWidget {
  const BirthTimePickerField({
    super.key,
    required this.value,
    required this.onChanged,
    this.label = 'Birth Time',
    this.hint = 'Select your birth time',
    this.enabled = true,
    this.errorText,
    this.onUnknownSelected,
    this.isUnknown = false,
    this.helperText,
  });

  final TimeOfDay? value;
  final void Function(TimeOfDay) onChanged;
  final String? label;
  final String hint;
  final bool enabled;
  final String? errorText;
  final VoidCallback? onUnknownSelected;
  final bool isUnknown;
  final String? helperText;

  @override
  Widget build(BuildContext context) {
    return TimePickerField(
      value: value,
      onChanged: onChanged,
      label: label,
      hint: hint,
      enabled: enabled,
      errorText: errorText,
      helperText: helperText ??
          'Accurate birth time helps create a more precise chart',
      showUnknownOption: true,
      onUnknownSelected: onUnknownSelected,
      isUnknown: isUnknown,
    );
  }
}
