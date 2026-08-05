import 'package:bnan_app/core/helper/my_snack_bar.dart';
import 'package:bnan_app/core/shared_widget/no_data_widget.dart';
import 'package:bnan_app/features/plans/presentation/models/plan_classroom_option.dart';
import 'package:bnan_app/features/plans/presentation/states/plans_classrooms_ui_state.dart';
import 'package:bnan_app/features/plans/presentation/views/widgets/plans_classrooms_source.dart';
import 'package:bnan_app/features/weekly_evaluations/presentation/manager/weekly_evaluations_cubit.dart';
import 'package:bnan_app/features/weekly_evaluations/presentation/manager/weekly_evaluations_state.dart';
import 'package:bnan_app/features/weekly_evaluations/presentation/policies/weekly_evaluations_access_policy.dart';
import 'package:bnan_app/features/weekly_evaluations/presentation/views/widgets/weekly_evaluation_filters.dart';
import 'package:bnan_app/features/weekly_evaluations/presentation/views/widgets/weekly_evaluations_failure.dart';
import 'package:bnan_app/features/weekly_evaluations/presentation/views/widgets/weekly_evaluations_header_actions.dart';
import 'package:bnan_app/features/weekly_evaluations/presentation/views/widgets/weekly_evaluations_skeleton.dart';
import 'package:bnan_app/features/weekly_evaluations/presentation/views/widgets/weekly_evaluations_students.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WeeklyEvaluationsBody extends StatelessWidget {
  const WeeklyEvaluationsBody({super.key, required this.policy});
  final WeeklyEvaluationsAccessPolicy policy;

  @override
  Widget build(BuildContext context) {
    if (policy.isParent) return _listener(context, null);
    return PlansClassroomsSource(
      builder: (context, state, _) {
        final classrooms = state is PlansClassroomsSuccess
            ? state.classrooms
            : null;
        if (classrooms != null) _syncClassrooms(context, classrooms);
        return _listener(
          context,
          classrooms,
          sourceError: state is PlansClassroomsFailure ? state.message : null,
        );
      },
    );
  }

  Widget _listener(
    BuildContext context,
    List<PlanClassroomOption>? classrooms, {
    String? sourceError,
  }) => BlocConsumer<WeeklyEvaluationsCubit, WeeklyEvaluationsState>(
    listenWhen: (_, state) => state is EvaluationSaved,
    listener: (context, _) => showCustomSnackBar(
      context,
      S.of(context).evaluationSavedSuccessfully,
      true,
    ),
    builder: (context, state) =>
        _content(context, state, classrooms, sourceError),
  );

  Widget _content(
    BuildContext context,
    WeeklyEvaluationsState state,
    List<PlanClassroomOption>? classrooms,
    String? sourceError,
  ) {
    final cubit = context.read<WeeklyEvaluationsCubit>();
    final response = cubit.response;
    final students = response == null
        ? null
        : WeeklyEvaluationsStudents(
            policy: policy,
            response: response,
            cubit: cubit,
          );
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 16, 24),
      child: Column(
        children: [
          if (policy.canAdd) ...[
            WeeklyEvaluationsHeaderActions(
              onAddPressed: students == null
                  ? null
                  : () => students.showAdd(
                      context,
                      classrooms ?? const <PlanClassroomOption>[],
                    ),
            ),
            const SizedBox(height: 12),
          ],
          WeeklyEvaluationFilters(cubit: cubit, classrooms: classrooms),
          const SizedBox(height: 16),
          Expanded(
            child: _result(context, state, cubit, students, sourceError),
          ),
        ],
      ),
    );
  }

  Widget _result(
    BuildContext context,
    WeeklyEvaluationsState state,
    WeeklyEvaluationsCubit cubit,
    WeeklyEvaluationsStudents? students,
    String? sourceError,
  ) {
    final response = cubit.response;
    if (sourceError != null) {
      return WeeklyEvaluationsFailure(message: sourceError);
    }
    if (_isInitialLoading(state) && response == null) {
      return const SingleChildScrollView(
        child: WeeklyEvaluationsSkeleton(showActions: false, showFilter: false),
      );
    }
    if (state is EvaluationsFailure) {
      return WeeklyEvaluationsFailure(message: state.message);
    }
    if (response == null) {
      return Center(child: NoDataWidget(title: _emptyTitle(context, cubit)));
    }
    if (response.data.students.every(
      (student) => student.subjects.every((subject) => !subject.isEvaluated),
    )) {
      return Center(
        child: NoDataWidget(title: S.of(context).noWeeklyEvaluations),
      );
    }
    return SingleChildScrollView(child: students!);
  }

  String _emptyTitle(BuildContext context, WeeklyEvaluationsCubit cubit) {
    if (cubit.selectedClassroom != null && cubit.availableWeeks.isEmpty) {
      return S.of(context).noEvaluationWeeksAvailable;
    }
    return S.of(context).noDataAvailable;
  }

  bool _isInitialLoading(WeeklyEvaluationsState state) =>
      state is WeeklyEvaluationsInitial ||
      state is ParentChildrenLoading ||
      state is EvaluationWeeksLoading ||
      state is EvaluationsLoading;

  void _syncClassrooms(
    BuildContext context,
    List<PlanClassroomOption> classrooms,
  ) => WidgetsBinding.instance.addPostFrameCallback((_) {
    if (context.mounted) {
      context.read<WeeklyEvaluationsCubit>().setClassrooms(classrooms);
    }
  });
}
