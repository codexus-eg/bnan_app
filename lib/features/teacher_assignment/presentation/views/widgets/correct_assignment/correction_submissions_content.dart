import 'package:bnan_app/features/teacher_assignment/data/model/student_assignment_submission.dart';
import 'package:flutter/material.dart';

import 'correction_summary.dart';
import 'student_submission_card.dart';

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
  });

  final List<StudentAssignmentSubmission> submissions;
  final String assignmentId;
  final num totalPoints;
  final int totalStudents;
  final int reviewed;
  final int submitted;
  final int notSubmitted;

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
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: submissions.length,
          itemBuilder: (context, index) {
            return StudentSubmissionCard(
              studentSubmission: submissions[index],
              assignmentId: assignmentId,
              totalPoints: totalPoints,
            );
          },
          separatorBuilder: (_, _) => const SizedBox(height: 16),
        ),
      ],
    );
  }
}
