import 'package:bnan_app/features/weekly_evaluations/presentation/manager/read_only/read_only_weekly_evaluations_cubit.dart';
import 'package:bnan_app/features/weekly_evaluations/presentation/manager/read_only/read_only_weekly_evaluations_state.dart';
import 'package:bnan_app/features/weekly_evaluations/presentation/views/read_only/read_only_weekly_evaluations_content.dart';
import 'package:bnan_app/features/weekly_evaluations/presentation/views/read_only/read_only_weekly_evaluations_filters.dart';
import 'package:bnan_app/features/weekly_evaluations/presentation/views/widgets/weekly_evaluations_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReadOnlyWeeklyEvaluationsBody extends StatelessWidget {
  const ReadOnlyWeeklyEvaluationsBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<
      ReadOnlyWeeklyEvaluationsCubit,
      ReadOnlyWeeklyEvaluationsState
    >(
      builder: (context, state) => SafeArea(
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 16, 24),
          child: Column(
            children: [
              ReadOnlyWeeklyEvaluationsFilters(state: state),
              const SizedBox(height: 16),
              Expanded(
                child: _isLoading(state)
                    ? const SingleChildScrollView(
                        child: WeeklyEvaluationsSkeleton(
                          showActions: false,
                          showFilter: false,
                        ),
                      )
                    : ReadOnlyWeeklyEvaluationsContent(state: state),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _isLoading(ReadOnlyWeeklyEvaluationsState state) =>
      state.isLoading &&
      (state.data == null ||
          state.isChangingWeek ||
          state.isChangingChild);
}
