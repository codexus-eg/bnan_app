import 'package:bnan_app/core/helper/app_pickers.dart';
import 'package:bnan_app/core/shared_widget/schedule_picker_field.dart';
import 'package:bnan_app/core/utils/assets.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class WeekStartField extends StatefulWidget {
  const WeekStartField({super.key, this.value});

  final String? value;

  @override
  State<WeekStartField> createState() => _WeekStartFieldState();
}

class _WeekStartFieldState extends State<WeekStartField> {
  String? selectedDate;

  @override
  void initState() {
    super.initState();
    selectedDate = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return SchedulePickerField(
      label: S.of(context).weekStart,
      hintText: 'mm/dd/yy',
      value: selectedDate,
      icon: ImageManager.calendarIcon,
      onTap: () async {
        final date = await AppPickers.pickDate(context: context);
        if (date == null) return;

        setState(() {
          selectedDate =
              '${date.month.toString().padLeft(2, '0')}/'
              '${date.day.toString().padLeft(2, '0')}/'
              '${date.year}';
        });
      },
    );
  }
}