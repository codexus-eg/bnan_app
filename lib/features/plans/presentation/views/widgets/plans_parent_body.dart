import 'package:bnan_app/core/shared_widget/no_data_widget.dart';
import 'package:bnan_app/features/plans/presentation/manager/get_parent_plans/get_parent_plans_cubit.dart';
import 'package:bnan_app/features/plans/presentation/manager/get_parent_plans/get_parent_plans_state.dart';
import 'package:bnan_app/features/plans/presentation/models/plan_classroom_option.dart';
import 'package:bnan_app/features/plans/presentation/policies/plans_access_policy.dart';
import 'package:bnan_app/features/plans/presentation/views/widgets/plans_classrooms_feedback.dart';
import 'package:bnan_app/features/plans/presentation/views/widgets/plans_filters_section.dart';
import 'package:bnan_app/features/plans/presentation/views/widgets/weekly_plans/plans_weekly_content.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PlansParentBody extends StatelessWidget {
  const PlansParentBody({super.key, required this.policy});

  final PlansAccessPolicy policy;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetParentPlansCubit, GetParentPlansState>(
      builder: (context, state) {
        final cubit = context.read<GetParentPlansCubit>();
        if (state is GetParentPlansEmpty && cubit.children.isEmpty) {
          return NoDataWidget(title: S.of(context).noChildrenAvailable);
        }
        return Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 16, 24),
          child: Column(
            children: [
              if (cubit.children.isNotEmpty) ...[
                _filters(context, cubit),
                const SizedBox(height: 16),
              ],
              Expanded(child: _content(context, cubit, state)),
            ],
          ),
        );
      },
    );
  }

  Widget _filters(BuildContext context, GetParentPlansCubit cubit) {
    final s = S.of(context);
    return PlansFiltersSection(
      policy: policy,
      classroom: null,
      classrooms: const [],
      classroomHint: '',
      week: cubit.selectedWeek,
      weeks: cubit.availableWeeks,
      weekHint: '${s.week} ${cubit.selectedWeek}',
      onClassroomChanged: (_) {},
      onWeekChanged: cubit.selectWeek,
      children: cubit.children,
      selectedChildId: cubit.selectedChildId,
      childHint: s.selectChild,
      onChildChanged: cubit.selectChild,
    );
  }

  Widget _content(
    BuildContext context,
    GetParentPlansCubit cubit,
    GetParentPlansState state,
  ) {
    final s = S.of(context);
    final title = cubit.selectedChildName.isEmpty
        ? s.studyPlanFor
        : '${s.studyPlanFor} - ${cubit.selectedChildName}';
    final selectedClassroom = cubit.selectedClassroom;
    final classroom = selectedClassroom == null
        ? null
        : PlanClassroomOption(
            id: selectedClassroom.id,
            name: selectedClassroom.name,
          );
    if (state is GetParentPlansFailure) {
      return PlansClassroomsFeedback(
        message: state.message,
        onRetry: cubit.retry,
      );
    }
    if (state is GetParentPlansLoading) {
      return SingleChildScrollView(
        child: PlansWeeklyContent(
          classroom: classroom,
          week: cubit.selectedWeek,
          showEmpty: false,
          externalLoading: true,
          titleOverride: title,
        ),
      );
    }
    final response = cubit.currentWeeklyPlan;
    if (response == null || response.data.subjects.isEmpty) {
      return NoDataWidget(title: s.noPlansAvailable);
    }
    return SingleChildScrollView(
      child: PlansWeeklyContent(
        classroom: classroom,
        week: cubit.selectedWeek,
        showEmpty: false,
        externalResponse: response,
        titleOverride: title,
      ),
    );
  }
}
