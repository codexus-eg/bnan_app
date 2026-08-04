import 'package:bnan_app/core/shared_widget/schedule_picker_field.dart';
import 'package:bnan_app/core/utils/assets.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class LessonStartTimeField extends StatelessWidget {
  const LessonStartTimeField({
    super.key,
    required this.value,
    required this.onTap,
  });

  final String? value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SchedulePickerField(
      label: S.of(context).startTime,
      hintText: S.of(context).startTime,
      value: value,
      icon: ImageManager.clockTenIcon,
      onTap: onTap,
    );
  }
}
