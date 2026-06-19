import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/features/student_schedule/presentation/views/widgets/schedule_widgets/schedule_grid_table.dart';
import 'package:flutter/material.dart';

class ScheduleTableCard extends StatelessWidget {
  const ScheduleTableCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsetsDirectional.all(8),
      decoration: BoxDecoration(
        color: ColorManager.greyF8F9,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: ColorManager.black.withAlpha((255 * .25).round()),
            blurRadius: 4,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: const ScheduleGridTable(),
    );
  }
}