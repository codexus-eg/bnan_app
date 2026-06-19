import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/teacher_assignment/presentation/widgets/dialogs/custom_dialog_header.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

import 'correction_summary.dart';
import 'student_submission_card.dart';

class CorrectAssignmentBody extends StatelessWidget {
  const CorrectAssignmentBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(14),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomDialogHeader(title: S.of(context).correctAssignment),
            const SizedBox(height: 16),
            Text(
              'تمارين الجمع والطرح',
              style: StylesManager.styleRegular16(
                context,
              ).copyWith(color: ColorManager.greyA8AF),
            ),
            const SizedBox(height: 16),
            const CorrectionSummary(),
            const SizedBox(height: 16),
            StudentSubmissionCard(
              status: StudentSubmissionStatus.corrected,
              grade: '9/10',
              buttonText: S.of(context).editGrade,
            ),
            const SizedBox(height: 16),
            StudentSubmissionCard(
              status: StudentSubmissionStatus.pending,
              buttonText: S.of(context).gradeAndAssignScore,
            ),
            const SizedBox(height: 16),
            const StudentSubmissionCard(
              status: StudentSubmissionStatus.notSubmitted,
            ),
          ],
        ),
      ),
    );
  }
}
