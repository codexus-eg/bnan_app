import 'package:bnan_app/core/shared_widget/custom_table/custom_table_row.dart';
import 'package:bnan_app/features/student_schedule/presentation/widgets/schedule_widgets/schedule_cell.dart';
import 'package:flutter/material.dart';

class DigitalScheduleGridHeader extends StatelessWidget {
  const DigitalScheduleGridHeader({
    super.key,
    required this.title,
    required this.times,
  });
  final String title;
  final List<String> times;

  @override
  Widget build(BuildContext context) => CustomTableRow(
    children: [
      ScheduleCell(text: title, width: 64, height: 48, isHeader: true),
      ...times.map(
        (time) => ScheduleCell(
          text: time,
          width: 92,
          height: 48,
          isHeader: true,
          isDark: true,
        ),
      ),
    ],
  );
}
