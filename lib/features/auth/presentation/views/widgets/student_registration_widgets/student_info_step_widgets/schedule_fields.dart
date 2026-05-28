import 'package:bnan_app/core/helper/app_pickers.dart';
import 'package:bnan_app/features/auth/presentation/views/widgets/student_registration_widgets/schedule_picker_field.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class ScheduleFields extends StatefulWidget {
  const ScheduleFields({super.key});

  @override
  State<ScheduleFields> createState() => _ScheduleFieldsState();
}

class _ScheduleFieldsState extends State<ScheduleFields> {
  DateTime? selectedDate;
  TimeOfDay? fromTime;
  TimeOfDay? toTime;

 Future<void> _pickDate() async {
  final date = await AppPickers.pickDate(
    context: context,
    initialDate: selectedDate,
  );

  if (date != null) {
    setState(() => selectedDate = date);
  }
}

Future<void> _pickTime({required bool isFrom}) async {
  final time = await AppPickers.pickTime(
    context: context,
    initialTime: isFrom ? fromTime : toTime,
  );

  if (time != null) {
    setState(() {
      if (isFrom) {
        fromTime = time;
      } else {
        toTime = time;
      }
    });
  }
}
  String _formatDate(DateTime date) {
    return '${date.month}/${date.day}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SchedulePickerField(
            label: S.of(context).availableDay,
            hintText: 'mm/dd/yy',
            value: selectedDate == null ? null : _formatDate(selectedDate!),
            icon: Icons.calendar_today_outlined,
            onTap: _pickDate,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: SchedulePickerField(
            label: S.of(context).from,
            hintText: '--:--',
            value: fromTime?.format(context),
            icon: Icons.access_time,
            onTap: () => _pickTime(isFrom: true),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: SchedulePickerField(
            label: S.of(context).to,
            hintText: '--:--',
            value: toTime?.format(context),
            icon: Icons.access_time,
            onTap: () => _pickTime(isFrom: false),
          ),
        ),
      ],
    );
  }
}
