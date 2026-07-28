import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/features/teacher_assignment/data/model/student_assignment_submission.dart';
import 'package:bnan_app/features/teacher_assignment/presentation/manager/get_assignment_submissions/get_assignment_submissions_cubit.dart';
import 'package:bnan_app/features/teacher_assignment/presentation/views/widgets/teacher_assignment_dialogs.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'student_submission_footer.dart';
import 'student_submission_header.dart';
import 'student_submission_status.dart';

class StudentSubmissionCard extends StatelessWidget {
  const StudentSubmissionCard({
    super.key,
    required this.studentSubmission,
    required this.assignmentId,
    required this.totalPoints,
  });

  final StudentAssignmentSubmission studentSubmission;
  final String assignmentId;
  final num totalPoints;

  @override
  Widget build(BuildContext context) {
    final status = studentSubmission.displayStatus;
    final submission = studentSubmission.submission;
    final canCorrect = studentSubmission.hasSubmitted && submission != null;
    final buttonText = canCorrect ? _buttonText(context, status) : null;
    final onCorrectionPressed = _correctionAction(context, submission);
    final showFooter =
        submission != null &&
        ((submission.attachment?.isNotEmpty ?? false) || buttonText != null);

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: status == StudentSubmissionStatus.notSubmitted
            ? ColorManager.redFFF
            : ColorManager.greyF8F9,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((255 * .25).round()),
            blurRadius: 4,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          StudentSubmissionHeader(
            studentSubmission: studentSubmission,
            status: status,
            totalPoints: totalPoints,
          ),
          if (showFooter) ...[
            const SizedBox(height: 10),
            StudentSubmissionFooter(
              attachment: submission.attachment,
              buttonText: buttonText,
              onCorrectionPressed: onCorrectionPressed,
            ),
          ],
        ],
      ),
    );
  }

  VoidCallback? _correctionAction(
    BuildContext context,
    AssignmentSubmissionDetailsModel? submission,
  ) {
    if (!studentSubmission.hasSubmitted || submission == null) return null;
    return () async {
      final result = await TeacherAssignmentDialogs.showSubmitCorrection(
        context,
        assignmentId: assignmentId,
        submissionId: submission.id,
        studentName: studentSubmission.fullName,
        totalPoints: totalPoints,
        currentScore: submission.score,
      );
      if (result == true && context.mounted) {
        context.read<GetAssignmentSubmissionsCubit>().getAssignmentSubmissions(
          assignmentId: assignmentId,
        );
      }
    };
  }

  String? _buttonText(BuildContext context, StudentSubmissionStatus status) {
    return switch (status) {
      StudentSubmissionStatus.reviewed => S.of(context).editGrade,
      StudentSubmissionStatus.submitted => S.of(context).gradeAndAssignScore,
      _ => null,
    };
  }
}
