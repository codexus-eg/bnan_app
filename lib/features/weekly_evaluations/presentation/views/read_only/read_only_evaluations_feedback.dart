import 'package:bnan_app/core/shared_widget/no_data_widget.dart';
import 'package:bnan_app/features/weekly_evaluations/data/read_only/models/evaluation_mode.dart';
import 'package:bnan_app/features/weekly_evaluations/presentation/manager/read_only/read_only_weekly_evaluations_state.dart';
import 'package:bnan_app/features/weekly_evaluations/presentation/views/read_only/read_only_failure_feedback.dart';
import 'package:bnan_app/features/weekly_evaluations/presentation/views/widgets/weekly_evaluations_skeleton.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

export 'read_only_inline_failure.dart';

class ReadOnlyEvaluationsFeedback extends StatelessWidget {
  const ReadOnlyEvaluationsFeedback({super.key, required this.state});
  static const _notEnrolledMessage = 'الطالب غير مقيد في هذا الفصل';
  static const _noClassroomMessage = 'الطالب غير مقيد في فصل';
  final ReadOnlyWeeklyEvaluationsState state;

  @override
  Widget build(BuildContext context) {
    if (state.isLoading) {
      return const SingleChildScrollView(
        child: WeeklyEvaluationsSkeleton(showActions: false, showFilter: false),
      );
    }
    if (state.status == ReadOnlyEvaluationsStatus.failure) {
      final message = state.failureMessage ?? '';
      return message.trim() == _notEnrolledMessage
          ? const NoDataWidget(title: _noClassroomMessage)
          : ReadOnlyFailureFeedback(message: message);
    }
    return NoDataWidget(title: _emptyTitle(context));
  }

  String _emptyTitle(BuildContext context) {
    final s = S.of(context);
    if (state.role == ReadOnlyEvaluationsRole.parent &&
        state.hasLoadedChildren &&
        state.children.isEmpty) {
      return s.noChildrenLinked;
    }
    if (state.hasNoClassroom) return s.noClassroomsAvailable;
    return switch (state.data?.mode) {
      EvaluationMode.gulf => s.noClassroomsAvailable,
      EvaluationMode.egyptian => s.noSubjectsAvailableReadOnly,
      _ => s.noWeeklyEvaluations,
    };
  }
}
