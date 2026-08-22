import 'package:bnan_app/features/student_schedule/presentation/models/digital_schedule_grid_data.dart';
import 'package:bnan_app/features/student_schedule/presentation/widgets/digital_schedule_grid/digital_schedule_content.dart';
import 'package:bnan_app/features/tables_management/presentation/views/widgets/table_schedules_failure.dart';
import 'package:flutter/material.dart';

class ParentScheduleResult extends StatelessWidget {
  const ParentScheduleResult({
    super.key,
    required this.initialLoading,
    required this.loading,
    required this.error,
    required this.onRetry,
    required this.data,
    required this.emptyMessage,
  });

  final bool initialLoading, loading;
  final String? error;
  final VoidCallback onRetry;
  final DigitalScheduleGridData data;
  final String emptyMessage;

  @override
  Widget build(BuildContext context) {
    if (initialLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (error != null) {
      return TableSchedulesFailure(message: error!, onRetry: onRetry);
    }
    return DigitalScheduleContent(
      data: data,
      loading: loading,
      emptyMessage: emptyMessage,
    );
  }
}
