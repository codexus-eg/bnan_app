import 'package:bnan_app/core/shared_widget/app_skeletonizer.dart';
import 'package:bnan_app/core/shared_widget/no_data_widget.dart';
import 'package:bnan_app/features/teacher_assignment/data/model/student_assignment_submission.dart';
import 'package:flutter/material.dart';

import 'student_submission_card.dart';

class CorrectionSubmissionsList extends StatelessWidget {
  const CorrectionSubmissionsList({
    super.key,
    required this.submissions,
    required this.assignmentId,
    required this.totalPoints,
    required this.isLoading,
    this.errorMessage,
  });

  final List<StudentAssignmentSubmission> submissions;
  final String assignmentId;
  final num totalPoints;
  final bool isLoading;
  final String? errorMessage;

  @override
  Widget build(BuildContext context) {
    if (errorMessage != null) {
      return NoDataWidget(title: errorMessage);
    }
    if (!isLoading && submissions.isEmpty) {
      return const NoDataWidget();
    }
    return AppSkeletonizer(
      isLoading: isLoading,
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: submissions.length,
        itemBuilder: (context, index) => StudentSubmissionCard(
          studentSubmission: submissions[index],
          assignmentId: assignmentId,
          totalPoints: totalPoints,
        ),
        separatorBuilder: (_, _) => const SizedBox(height: 16),
      ),
    );
  }
}
