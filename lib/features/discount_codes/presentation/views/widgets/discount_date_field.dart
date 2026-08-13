import 'package:bnan_app/core/helper/app_pickers.dart';
import 'package:bnan_app/core/shared_widget/schedule_picker_field.dart';
import 'package:bnan_app/core/utils/assets.dart';
import 'package:flutter/material.dart';

class DiscountDateField extends StatelessWidget {
  const DiscountDateField({
    super.key,
    required this.label,
    required this.value,
    required this.firstDate,
    required this.onChanged,
  });
  final String label;
  final DateTime? value;
  final DateTime firstDate;
  final ValueChanged<DateTime> onChanged;

  @override
  Widget build(BuildContext context) {
    final text = value == null
        ? ''
        : MaterialLocalizations.of(context).formatShortDate(value!.toLocal());
    return SchedulePickerField(
      label: label,
      hintText: '',
      value: text.isEmpty ? null : text,
      icon: ImageManager.teacherAssignmentDateIcon,
      onTap: () async {
        final date = await AppPickers.pickDate(
          context: context,
          initialDate: _initial,
          firstDate: firstDate,
          lastDate: DateTime(2100),
        );
        if (date != null && context.mounted) onChanged(date);
      },
    );
  }

  DateTime get _initial {
    final selected = value;
    if (selected == null || selected.isBefore(firstDate)) return firstDate;
    return selected;
  }
}
