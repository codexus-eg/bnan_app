import 'package:bnan_app/core/shared_widget/app_skeletonizer.dart';
import 'package:bnan_app/core/shared_widget/no_data_widget.dart';
import 'package:bnan_app/features/ideal_teacher/data/models/ideal_teacher_skeleton_data.dart';
import 'package:bnan_app/features/ideal_teacher/presentation/manager/supervisor_ideal_teacher_cubit.dart';
import 'package:bnan_app/features/ideal_teacher/presentation/manager/supervisor_ideal_teacher_state.dart';
import 'package:bnan_app/features/ideal_teacher/presentation/views/widgets/ideal_teacher_failure.dart';
import 'package:bnan_app/features/ideal_teacher/presentation/views/widgets/ideal_teacher_list.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class IdealTeacherResult extends StatelessWidget {
  const IdealTeacherResult({super.key, required this.state});
  final SupervisorIdealTeacherState state;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SupervisorIdealTeacherCubit>();
    if (state.status == SupervisorIdealTeacherStatus.loadingTeachers) {
      return const AppSkeletonizer(
        isLoading: true,
        child: IdealTeacherList(
          teachers: idealTeacherSkeleton,
          selectedIds: {},
          onToggle: null,
        ),
      );
    }
    if (state.status == SupervisorIdealTeacherStatus.failure &&
        state.teachers.isEmpty) {
      return IdealTeacherFailure(message: state.message, onRetry: cubit.retry);
    }
    if (state.teachers.isEmpty) {
      return NoDataWidget(title: S.of(context).noTeachersAvailable);
    }
    return RefreshIndicator(
      onRefresh: cubit.loadTeachers,
      child: IdealTeacherList(
        teachers: state.teachers,
        selectedIds: state.selectedTeacherIds,
        onToggle: state.isSubmitting ? null : cubit.toggleTeacher,
      ),
    );
  }
}
