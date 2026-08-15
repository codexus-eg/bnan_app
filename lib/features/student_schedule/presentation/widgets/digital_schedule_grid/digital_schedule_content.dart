import 'package:bnan_app/core/shared_widget/app_skeletonizer.dart';
import 'package:bnan_app/core/shared_widget/no_data_widget.dart';
import 'package:bnan_app/features/student_schedule/presentation/models/digital_schedule_grid_data.dart';
import 'package:bnan_app/features/student_schedule/presentation/widgets/digital_schedule_grid/digital_schedule_grid.dart';
import 'package:flutter/material.dart';

class DigitalScheduleContent extends StatelessWidget {
  const DigitalScheduleContent({
    super.key,
    required this.data,
    required this.emptyMessage,
    this.loading = false,
  });
  final DigitalScheduleGridData data;
  final String emptyMessage;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    if (data.days.isEmpty || data.times.isEmpty) {
      return NoDataWidget(title: emptyMessage);
    }
    return AppSkeletonizer(
      isLoading: loading,
      child: SingleChildScrollView(
        padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 16, 24),
        child: DigitalScheduleGrid(data: data),
      ),
    );
  }
}
