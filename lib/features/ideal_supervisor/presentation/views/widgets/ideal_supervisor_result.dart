import 'package:bnan_app/core/shared_widget/no_data_widget.dart';
import 'package:bnan_app/core/shared_widget/app_skeletonizer.dart';
import 'package:bnan_app/features/ideal_supervisor/data/models/ideal_supervisor_skeleton_data.dart';
import 'package:bnan_app/features/ideal_supervisor/presentation/manager/admin_ideal_supervisor_cubit.dart';
import 'package:bnan_app/features/ideal_supervisor/presentation/manager/admin_ideal_supervisor_state.dart';
import 'package:bnan_app/features/ideal_supervisor/presentation/policies/ideal_supervisor_error_mapper.dart';
import 'package:bnan_app/features/ideal_supervisor/presentation/views/widgets/ideal_supervisor_list.dart';
import 'package:bnan_app/features/ideal_teacher/presentation/views/widgets/ideal_teacher_failure.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class IdealSupervisorResult extends StatelessWidget {
  const IdealSupervisorResult({super.key, required this.state});
  final AdminIdealSupervisorState state;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AdminIdealSupervisorCubit>();
    if (state.status == AdminIdealSupervisorStatus.loading) {
      return const AppSkeletonizer(
        isLoading: true,
        child: IdealSupervisorList(
          supervisors: idealSupervisorSkeleton,
          selectedIds: {},
          onToggle: null,
        ),
      );
    }
    if (state.status == AdminIdealSupervisorStatus.failure &&
        state.supervisors.isEmpty) {
      return IdealTeacherFailure(
        message: idealSupervisorError(
          S.of(context),
          state.errorCode,
          state.message,
        ),
        onRetry: cubit.load,
      );
    }
    if (state.supervisors.isEmpty) {
      return NoDataWidget(title: S.of(context).noSupervisorsFound);
    }
    return RefreshIndicator(
      onRefresh: cubit.load,
      child: IdealSupervisorList(
        supervisors: state.supervisors,
        selectedIds: state.selectedIds,
        onToggle: state.isSubmitting ? null : cubit.toggle,
      ),
    );
  }
}
