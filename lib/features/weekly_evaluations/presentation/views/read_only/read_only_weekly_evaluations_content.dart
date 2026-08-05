import 'package:bnan_app/features/weekly_evaluations/data/read_only/models/evaluation_mode.dart';
import 'package:bnan_app/features/weekly_evaluations/presentation/manager/read_only/read_only_weekly_evaluations_state.dart';
import 'package:bnan_app/features/weekly_evaluations/presentation/views/read_only/egyptian_evaluations_list.dart';
import 'package:bnan_app/features/weekly_evaluations/presentation/views/read_only/gulf_evaluations_list.dart';
import 'package:bnan_app/features/weekly_evaluations/presentation/views/read_only/read_only_evaluations_feedback.dart';
import 'package:flutter/material.dart';

class ReadOnlyWeeklyEvaluationsContent extends StatelessWidget {
  const ReadOnlyWeeklyEvaluationsContent({super.key, required this.state});
  final ReadOnlyWeeklyEvaluationsState state;

  @override
  Widget build(BuildContext context) {
    final data = state.data;
    if (data == null || state.status == ReadOnlyEvaluationsStatus.empty) {
      return ReadOnlyEvaluationsFeedback(state: state);
    }
    final content = switch (data.mode) {
      EvaluationMode.gulf => GulfEvaluationsList(data: data),
      EvaluationMode.egyptian => EgyptianEvaluationsList(data: data),
      EvaluationMode.unknown when data.classrooms.isNotEmpty =>
        GulfEvaluationsList(data: data),
      EvaluationMode.unknown when data.subjects.isNotEmpty =>
        EgyptianEvaluationsList(data: data),
      EvaluationMode.unknown => ReadOnlyEvaluationsFeedback(state: state),
    };
    if (state.failureMessage == null) return content;
    return Column(
      children: [
        ReadOnlyInlineFailure(message: state.failureMessage!),
        const SizedBox(height: 8),
        Expanded(child: content),
      ],
    );
  }
}
