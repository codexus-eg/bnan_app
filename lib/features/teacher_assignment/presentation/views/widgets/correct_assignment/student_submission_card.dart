import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:flutter/material.dart';

import 'student_submission_footer.dart';
import 'student_submission_header.dart';

enum StudentSubmissionStatus {
  corrected,
  pending,
  notSubmitted,
}

class StudentSubmissionCard extends StatelessWidget {
  const StudentSubmissionCard({
    super.key,
    required this.status,
    this.buttonText,
    this.grade,
  });

  final StudentSubmissionStatus status;
  final String? buttonText;
  final String? grade;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: status == StudentSubmissionStatus.notSubmitted
            ? ColorManager.redFFF
            : ColorManager.greyF8F9,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((255*.25).round()),
            blurRadius: 4,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          StudentSubmissionHeader(
            status: status,
            grade: grade, 
          ),
          if (status != StudentSubmissionStatus.notSubmitted) ...[
            const SizedBox(height: 10),
            StudentSubmissionFooter(
              buttonText: buttonText!,
            ),
          ],
        ],
      ),
    );
  }
}