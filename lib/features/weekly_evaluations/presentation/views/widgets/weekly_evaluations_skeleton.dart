import 'package:bnan_app/core/shared_widget/app_skeletonizer.dart';
import 'package:bnan_app/features/weekly_evaluations/presentation/models/weekly_evaluation_subject_ui_model.dart';
import 'package:bnan_app/features/weekly_evaluations/presentation/models/weekly_evaluation_ui_model.dart';
import 'package:bnan_app/features/weekly_evaluations/presentation/views/widgets/weekly_evaluation_card.dart';
import 'package:bnan_app/features/weekly_evaluations/presentation/views/widgets/weekly_evaluations_classroom_filter.dart';
import 'package:bnan_app/features/weekly_evaluations/presentation/views/widgets/weekly_evaluations_header_actions.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class WeeklyEvaluationsSkeleton extends StatelessWidget {
  const WeeklyEvaluationsSkeleton({
    super.key,
    required this.showActions,
    required this.showFilter,
  });

  final bool showActions;
  final bool showFilter;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final evaluation = WeeklyEvaluationUiModel(
      id: 'skeleton',
      title: s.weeklyEvaluation,
      subjects: [
        WeeklyEvaluationSubjectUiModel(
          subjectName: s.subject,
          attendance: s.excellent,
          participation: s.excellent,
          homework: s.excellent,
          notes: s.notesText,
        ),
      ],
    );
    return AppSkeletonizer(
      isLoading: true,
      child: Column(
        children: [
          if (showActions) ...[
            const WeeklyEvaluationsHeaderActions(),
            const SizedBox(height: 16),
          ],
          if (showFilter) ...[
            WeeklyEvaluationsClassroomFilter(
              classrooms: const ['classroom'],
              selectedClassroom: 'classroom',
              onChanged: (_) {},
            ),
            const SizedBox(height: 16),
          ],
          WeeklyEvaluationCard(
            evaluation: evaluation,
            showEditAction: showActions,
          ),
        ],
      ),
    );
  }
}
