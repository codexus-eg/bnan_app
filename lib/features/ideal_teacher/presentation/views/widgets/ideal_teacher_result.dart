import 'package:bnan_app/core/session/session_manager.dart';
import 'package:bnan_app/core/shared_widget/app_skeletonizer.dart';
import 'package:bnan_app/core/shared_widget/no_data_widget.dart';
import 'package:bnan_app/features/ideal_teacher/data/models/ideal_teacher_skeleton_data.dart';
import 'package:bnan_app/features/ideal_teacher/presentation/manager/supervisor_ideal_teacher_cubit.dart';
import 'package:bnan_app/features/ideal_teacher/presentation/manager/supervisor_ideal_teacher_state.dart';
import 'package:bnan_app/features/ideal_teacher/presentation/policies/ideal_teacher_access_policy.dart';
import 'package:bnan_app/features/ideal_teacher/presentation/views/widgets/ideal_teacher_failure.dart';
import 'package:bnan_app/features/ideal_teacher/presentation/views/widgets/ideal_teacher_list.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class IdealTeacherResult extends StatelessWidget {
  const IdealTeacherResult({
    super.key,
    required this.state,
    this.scrollController,
  });

  final SupervisorIdealTeacherState state;
  final ScrollController? scrollController;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SupervisorIdealTeacherCubit>();
    final role = SessionManager.instance.role;
    final canModify = IdealTeacherAccessPolicy.canModify(role);
    final canSelect = IdealTeacherAccessPolicy.canSelectTeachers(role);

    if (state.isLoading) {
      return const AppSkeletonizer(
        isLoading: true,
        child: IdealTeacherList(
          ranking: teacherRankingSkeleton,
          selectedIds: {},
          canModify: false,
          canSelect: false,
          onToggle: null,
        ),
      );
    }
    if (state.status == SupervisorIdealTeacherStatus.failure &&
        state.ranking.isEmpty) {
      final isEgyptianOnly = state.isEgyptianOnlyClassroom;
      final isAr = Localizations.localeOf(context).languageCode == 'ar';
      final message = isEgyptianOnly
          ? (isAr
              ? 'هذه الميزة متاحة للفصول التابعة للنظام المصري فقط'
              : 'This feature is available for Egyptian classrooms only')
          : state.message;
      return IdealTeacherFailure(
        message: message,
        onRetry: isEgyptianOnly ? null : cubit.retry,
      );
    }
    if (state.filteredRanking.isEmpty) {
      return NoDataWidget(title: S.of(context).noTeachersAvailable);
    }
    return RefreshIndicator(
      onRefresh: cubit.refresh,
      child: IdealTeacherList(
        ranking: state.filteredRanking,
        selectedIds: state.selectedTeacherIds,
        canModify: canModify,
        canSelect: canSelect,
        onToggle: canSelect && !state.isSubmitting ? cubit.toggleTeacher : null,
        scrollController: scrollController,
      ),
    );
  }
}
