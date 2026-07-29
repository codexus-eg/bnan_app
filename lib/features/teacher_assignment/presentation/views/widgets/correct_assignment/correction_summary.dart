import 'package:bnan_app/core/utils/assets.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

import 'correction_summary_item.dart';

class CorrectionSummary extends StatelessWidget {
  const CorrectionSummary({
    super.key,
    required this.totalStudents,
    required this.reviewed,
    required this.submitted,
    required this.notSubmitted,
  });

  final int totalStudents;
  final int reviewed;
  final int submitted;
  final int notSubmitted;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: CorrectionSummaryItem(
            count: reviewed,
            title: S.of(context).graded,
            image: ImageManager.teacherAssignmentCheckContainedIcon,
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: CorrectionSummaryItem(
            count: submitted,
            title: S.of(context).waitingForCorrection,
            image: ImageManager.teacherAssignmentClockIcon,
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: CorrectionSummaryItem(
            count: notSubmitted,
            title: S.of(context).notSubmitted,
            image: ImageManager.teacherAssignmentCircleWarningIcon,
          ),
        ),
      ],
    );
  }
}
