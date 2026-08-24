import 'package:bnan_app/core/helper/app_pickers.dart';
import 'package:bnan_app/core/helper/validator_form_field.dart';
import 'package:bnan_app/core/shared_widget/custom_text_field.dart';
import 'package:bnan_app/core/utils/assets.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PlanDateField extends StatelessWidget {
  const PlanDateField({
    super.key,
    required this.controller,
    required this.selectedDate,
    required this.startDate,
    required this.onDateChanged,
  });

  final TextEditingController controller;
  final DateTime? selectedDate;
  final DateTime startDate;
  final ValueChanged<DateTime> onDateChanged;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return CustomTextField(
      label: s.today,
      hintText: s.dateFormatHint,
      controller: controller,
      isRequired: true,
      readOnly: true,
      validator: (value) {
        final requiredError = MyValidator.requiredField(value, s.day);
        if (requiredError != null) return requiredError;
        final date = selectedDate;
        if (date != null &&
            _dateOnly(date).isAfter(_dateOnly(DateTime.now()))) {
          return s.futurePlanDateNotAllowed;
        }
        return null;
      },
      onTap: () => _pickDate(context),
      prefixIcon: Padding(
        padding: const EdgeInsetsDirectional.only(end: 10, start: 10),
        child: SvgPicture.asset(ImageManager.teacherAssignmentDateIcon),
      ),
    );
  }

  Future<void> _pickDate(BuildContext context) async {
    final today = _dateOnly(DateTime.now());
    final firstAllowedDate = _dateOnly(startDate);
    final date = await AppPickers.pickDate(
      context: context,
      initialDate: _clampDate(selectedDate ?? today, firstAllowedDate, today),
      firstDate: firstAllowedDate,
      lastDate: today,
    );
    if (date != null && context.mounted) {
      controller.text = MaterialLocalizations.of(context).formatShortDate(date);
      onDateChanged(date);
    }
  }

  DateTime _dateOnly(DateTime date) =>
      DateTime(date.year, date.month, date.day);

  DateTime _clampDate(DateTime date, DateTime firstDate, DateTime lastDate) {
    final normalizedDate = _dateOnly(date);
    if (normalizedDate.isBefore(firstDate)) return firstDate;
    if (normalizedDate.isAfter(lastDate)) return lastDate;
    return normalizedDate;
  }
}
