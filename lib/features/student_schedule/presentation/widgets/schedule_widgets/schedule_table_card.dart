import 'package:bnan_app/core/shared_widget/custom_table/custom_table_container.dart';
import 'package:bnan_app/features/student_schedule/presentation/widgets/schedule_widgets/schedule_grid_table.dart';
import 'package:flutter/material.dart';

class ScheduleTableCard extends StatelessWidget {
  const ScheduleTableCard({super.key});

  @override
  Widget build(BuildContext context) {
    return const CustomTableContainer(child: ScheduleGridTable());
  }
}
