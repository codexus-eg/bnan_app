import 'package:bnan_app/core/shared_widget/schedule_picker_field.dart';
import 'package:bnan_app/core/utils/assets.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class LessonTimeFields extends StatelessWidget {
  const LessonTimeFields({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SchedulePickerField(
            label: S.of(context).startTime,
            value: null,
            icon: ImageManager.clockTenIcon,
            onTap: () {},
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: SchedulePickerField(
            label: S.of(context).endTime,
            value: null,
            icon: ImageManager.clockTenIcon,
            onTap: () {},
          ),
        ),
      ],
    );
  }
}
