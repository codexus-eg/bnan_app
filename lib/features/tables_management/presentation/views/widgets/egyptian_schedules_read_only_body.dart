import 'package:bnan_app/features/tables_management/presentation/manager/get_egyptian_schedules_cubit/get_egyptian_schedules_cubit.dart';
import 'package:bnan_app/features/tables_management/presentation/views/widgets/table_schedules_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EgyptianSchedulesReadOnlyBody extends StatelessWidget {
  const EgyptianSchedulesReadOnlyBody({
    super.key,
    this.applyTopSafeArea = true,
  });

  final bool applyTopSafeArea;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: applyTopSafeArea,
      bottom: false,
      child: TableSchedulesContent(
        canManage: false,
        showAcademicDetails: true,
        onRetry: context
            .read<GetEgyptianSchedulesCubit>()
            .getMyEgyptianSchedule,
      ),
    );
  }
}
