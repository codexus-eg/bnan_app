import 'package:bnan_app/core/shared_widget/custom_table/custom_table_container.dart';
import 'package:bnan_app/features/lessons_management/presentation/models/lesson_days.dart';
import 'package:bnan_app/features/student_schedule/presentation/models/digital_schedule_grid_data.dart';
import 'package:bnan_app/features/student_schedule/presentation/widgets/digital_schedule_grid/digital_schedule_grid_header.dart';
import 'package:bnan_app/features/student_schedule/presentation/widgets/digital_schedule_grid/digital_schedule_grid_row.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class DigitalScheduleGrid extends StatelessWidget {
  const DigitalScheduleGrid({super.key, required this.data});
  final DigitalScheduleGridData data;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) => SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: ConstrainedBox(
        constraints: BoxConstraints(minWidth: constraints.maxWidth),
        child: Align(
          alignment: AlignmentDirectional.centerStart,
          child: CustomTableContainer(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DigitalScheduleGridHeader(
                  title: S.of(context).time,
                  times: data.times,
                ),
                ...data.days.map(
                  (day) => DigitalScheduleGridRow(
                    day: lessonDayLabel(S.of(context), day),
                    cells: data.times
                        .map((time) => data.items(day, time))
                        .toList(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
