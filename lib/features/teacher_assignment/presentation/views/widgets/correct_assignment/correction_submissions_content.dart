import 'package:bnan_app/features/teacher_assignment/data/model/student_assignment_submission.dart';
import 'package:flutter/material.dart';

import 'correction_summary.dart';
import 'correction_submissions_list.dart';

class CorrectionSubmissionsContent extends StatelessWidget {
  const CorrectionSubmissionsContent({
    super.key,
    required this.submissions,
    required this.assignmentId,
    required this.totalPoints,
    required this.totalStudents,
    required this.reviewed,
    required this.submitted,
    required this.notSubmitted,
    required this.isLoading,
    this.errorMessage,
  });

  final List<StudentAssignmentSubmission> submissions;
  final String assignmentId;
  final num totalPoints;
  final int totalStudents;
  final int reviewed;
  final int submitted;
  final int notSubmitted;
  final bool isLoading;
  final String? errorMessage;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CorrectionSummary(
          totalStudents: totalStudents,
          reviewed: reviewed,
          submitted: submitted,
          notSubmitted: notSubmitted,
        ),
        const SizedBox(height: 16),
        CorrectionSubmissionsList(
          submissions: submissions,
          assignmentId: assignmentId,
          totalPoints: totalPoints,
          isLoading: isLoading,
          errorMessage: errorMessage,
        ),
      ],
    );
  }
}
