import 'package:bnan_app/features/plans/presentation/manager/get_elapsed_weeks/get_elapsed_weeks_state.dart';
import 'package:bnan_app/features/plans/presentation/models/plan_classroom_option.dart';
import 'package:bnan_app/features/plans/presentation/policies/plans_access_policy.dart';
import 'package:bnan_app/features/plans/presentation/states/plans_classrooms_ui_state.dart';
import 'package:bnan_app/features/plans/presentation/views/widgets/plans_classrooms_feedback.dart';
import 'package:bnan_app/features/plans/presentation/views/widgets/plans_classrooms_source.dart';
import 'package:bnan_app/features/plans/presentation/views/widgets/plans_filters_section.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class PlansClassroomWeekFilters extends StatelessWidget {
  const PlansClassroomWeekFilters({
    super.key,
    required this.policy,
    required this.selectedClassroom,
    required this.selectedWeek,
    required this.weeksCount,
    required this.elapsedState,
    required this.onClassroomChanged,
    required this.onWeekChanged,
    required this.onRetryElapsedWeeks,
    required this.onClassroomsChanged,
  });

  final PlansAccessPolicy policy;
  final PlanClassroomOption? selectedClassroom;
  final int? selectedWeek;
  final int weeksCount;
  final GetElapsedWeeksState elapsedState;
  final ValueChanged<PlanClassroomOption?> onClassroomChanged;
  final ValueChanged<int?> onWeekChanged;
  final VoidCallback onRetryElapsedWeeks;
  final ValueChanged<List<PlanClassroomOption>> onClassroomsChanged;

  @override
  Widget build(BuildContext context) {
    return PlansClassroomsSource(
      policy: policy,
      builder: (context, state, retry) => _build(context, state, retry),
    );
  }

  Widget _build(
    BuildContext context,
    PlansClassroomsUiState state,
    VoidCallback retry,
  ) {
    return switch (state) {
      PlansClassroomsLoading() => _filters(
        context,
        null,
        S.of(context).loadingClassrooms,
      ),
      PlansClassroomsEmpty() => _empty(),
      PlansClassroomsFailure() => Column(
        children: [
          _filters(context, null, S.of(context).chooseClassRoom),
          PlansClassroomsFeedback(message: state.message, onRetry: retry),
        ],
      ),
      PlansClassroomsSuccess() => _success(context, state.classrooms),
    };
  }

  Widget _empty() {
    onClassroomsChanged(const []);
    return const SizedBox.shrink();
  }

  Widget _success(BuildContext context, List<PlanClassroomOption> classrooms) {
    onClassroomsChanged(classrooms);
    return Column(
      children: [
        _filters(context, classrooms, S.of(context).chooseClassRoom),
        if (classrooms.isEmpty)
          PlansClassroomsFeedback(message: S.of(context).noClassroomsAvailable)
        else if (selectedClassroom != null &&
            elapsedState is GetElapsedWeeksFailure)
          PlansClassroomsFeedback(
            message: (elapsedState as GetElapsedWeeksFailure).message,
            onRetry: onRetryElapsedWeeks,
          ),
      ],
    );
  }

  Widget _filters(
    BuildContext context,
    List<PlanClassroomOption>? classrooms,
    String classroomHint,
  ) {
    final weekHint = selectedWeek != null
        ? '${S.of(context).week} $selectedWeek'
        : elapsedState is GetElapsedWeeksLoading
        ? S.of(context).loading
        : selectedClassroom == null
        ? S.of(context).selectClassroomFirst
        : S.of(context).selectWeek;
    return PlansFiltersSection(
      policy: policy,
      classroom: selectedClassroom,
      classrooms: classrooms,
      classroomHint: classroomHint,
      week: selectedWeek,
      weeks: _weekOptions,
      weekHint: weekHint,
      onClassroomChanged: onClassroomChanged,
      onWeekChanged: onWeekChanged,
    );
  }

  List<int>? get _weekOptions {
    if (elapsedState is GetElapsedWeeksLoading ||
        elapsedState is GetElapsedWeeksFailure) {
      return null;
    }
    if (selectedClassroom == null || weeksCount <= 0) return const [];
    return List<int>.generate(weeksCount, (index) => index + 1);
  }
}
