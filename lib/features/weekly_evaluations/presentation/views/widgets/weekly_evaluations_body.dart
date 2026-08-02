import 'package:bnan_app/core/helper/my_snack_bar.dart';
import 'package:bnan_app/core/shared_widget/no_data_widget.dart';
import 'package:bnan_app/features/plans/presentation/models/plan_classroom_option.dart';
import 'package:bnan_app/features/plans/presentation/states/plans_classrooms_ui_state.dart';
import 'package:bnan_app/features/plans/presentation/views/widgets/plans_classrooms_source.dart';
import 'package:bnan_app/features/weekly_evaluations/presentation/manager/weekly_evaluations_cubit.dart';
import 'package:bnan_app/features/weekly_evaluations/presentation/manager/weekly_evaluations_state.dart';
import 'package:bnan_app/features/weekly_evaluations/presentation/mappers/evaluation_ui_text.dart';
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
      builder: (context, state, retry) {
        final classrooms = state is PlansClassroomsSuccess
            ? state.classrooms
            : null;
        if (classrooms != null) _syncClassrooms(context, classrooms);
        return _listener(
          context,
          classrooms,
          sourceError: state is PlansClassroomsFailure ? state.message : null,
          sourceRetry: retry,
        );
      },
    );
  }

  Widget _listener(
    BuildContext context,
    List<PlanClassroomOption>? classrooms, {
    String? sourceError,
    VoidCallback? sourceRetry,
  }) => BlocConsumer<WeeklyEvaluationsCubit, WeeklyEvaluationsState>(
    listenWhen: (_, state) => state is EvaluationSaved,
    listener: (context, _) =>
        showCustomSnackBar(context, EvaluationUiText.saved(context), true),
    builder: (context, state) =>
        _content(context, state, classrooms, sourceError, sourceRetry),
  );

  Widget _content(
    BuildContext context,
    WeeklyEvaluationsState state,
    List<PlanClassroomOption>? classrooms,
    String? sourceError,
    VoidCallback? sourceRetry,
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
    return ListView(
      padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 16, 24),
      children: [
        if (policy.canAdd) ...[
          WeeklyEvaluationsHeaderActions(
            onAddPressed: students == null
                ? null
                : () => students.showAdd(context),
          ),
          const SizedBox(height: 12),
        ],
        WeeklyEvaluationFilters(cubit: cubit, classrooms: classrooms),
        const SizedBox(height: 16),
        if (sourceError != null)
          WeeklyEvaluationsFailure(message: sourceError, onRetry: sourceRetry)
        else if (_isInitialLoading(state) && response == null)
          WeeklyEvaluationsSkeleton(showActions: false, showFilter: false)
        else if (state is EvaluationsFailure)
          WeeklyEvaluationsFailure(message: state.message, onRetry: cubit.retry)
        else if (response == null)
          NoDataWidget(title: _emptyTitle(context, cubit))
        else if (response.data.students.isEmpty)
          NoDataWidget(title: EvaluationUiText.noWeekEvaluations(context))
        else
          students!,
      ],
    );
  }

  String _emptyTitle(BuildContext context, WeeklyEvaluationsCubit cubit) {
    if (cubit.selectedClassroom != null && cubit.availableWeeks.isEmpty) {
      return EvaluationUiText.noWeeks(context);
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
