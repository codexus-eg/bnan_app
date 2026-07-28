import 'package:bnan_app/core/shared_widget/custom_avatar.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/teacher_assignment/data/model/student_assignment_submission.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'student_submission_status.dart';

class StudentSubmissionHeader extends StatelessWidget {
  const StudentSubmissionHeader({
    super.key,
    required this.studentSubmission,
    required this.status,
    required this.totalPoints,
  });

  final StudentAssignmentSubmission studentSubmission;
  final StudentSubmissionStatus status;
  final num totalPoints;

  @override
  Widget build(BuildContext context) {
    final isNotSubmitted = status == StudentSubmissionStatus.notSubmitted;
    final submission = studentSubmission.submission;
    final score = submission?.score;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomAvatar(
          firstName: studentSubmission.fullName,
          radius: 20,
          backgroundColor: isNotSubmitted ? ColorManager.redFFD : null,
          textColor: isNotSubmitted ? ColorManager.redC7 : null,
        ),
        const SizedBox(width: 17),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                studentSubmission.fullName,
                style: StylesManager.styleBold16(
                  context,
                ).copyWith(color: ColorManager.mainColor14),
              ),
              const SizedBox(height: 4),
              Text(
                _detailsText(context, submission?.submittedAt),
                style: StylesManager.styleRegular14(context).copyWith(
                  color: isNotSubmitted
                      ? ColorManager.redC7
                      : ColorManager.greyA8AF,
                ),
              ),
            ],
          ),
        ),
        if (score != null)
          Column(
            children: [
              Text(
                '${_formatNumber(score)}/${_formatNumber(totalPoints)}',
                style: StylesManager.styleBold16(
                  context,
                ).copyWith(color: ColorManager.black),
              ),
              Text(
                _statusLabel(context),
                style: StylesManager.styleRegular14(
                  context,
                ).copyWith(color: ColorManager.greyA8AF),
              ),
            ],
          ),
      ],
    );
  }

  String _detailsText(BuildContext context, DateTime? submittedAt) {
    if (status == StudentSubmissionStatus.notSubmitted) {
      return S.of(context).assignmentNotSubmittedYet;
    }

    final label = _statusLabel(context);
    if (submittedAt == null) return label;
    final date = DateFormat('dd/MM/yyyy', 'en').format(submittedAt.toLocal());
    return '$label • ${S.of(context).submissionDate} $date';
  }

  String _statusLabel(BuildContext context) {
    return switch (status) {
      StudentSubmissionStatus.reviewed => S.of(context).graded,
      StudentSubmissionStatus.submitted => S.of(context).submitted,
      StudentSubmissionStatus.notSubmitted => S.of(context).notSubmitted,
      StudentSubmissionStatus.unknown =>
        studentSubmission.hasSubmitted
            ? S.of(context).submittedBadge
            : S.of(context).notSubmitted,
    };
  }

  String _formatNumber(num value) {
    return value % 1 == 0 ? value.toInt().toString() : value.toString();
  }
}
