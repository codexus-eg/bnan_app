import 'package:bnan_app/core/shared_widget/schedule_picker_field.dart';
import 'package:bnan_app/core/utils/assets.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class LessonDateField extends StatelessWidget {
  const LessonDateField({super.key});

  @override
  Widget build(BuildContext context) {
    return SchedulePickerField(
      label: S.of(context).lessonDate,
      hintText: S.of(context).lessonDate,
      value: null,
      icon: ImageManager.calendarIcon,
      onTap: () {},
    );
  }
}
