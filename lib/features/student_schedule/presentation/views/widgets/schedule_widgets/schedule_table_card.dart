import 'package:bnan_app/core/shared_widget/custom_details_widget_background.dart';
import 'package:bnan_app/features/student_schedule/presentation/views/widgets/schedule_widgets/schedule_grid_table.dart';
import 'package:flutter/material.dart';

class ScheduleTableCard extends StatelessWidget {
  const ScheduleTableCard({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomDetailsWidgetBackground(
     
      child: const ScheduleGridTable(),
    );
  }
}