import 'package:bnan_app/features/certificates_management/presentation/views/widgets/grade_box.dart';
import 'package:bnan_app/features/certificates_management/presentation/views/widgets/grade_input_box.dart';
import 'package:flutter/material.dart';

class CertificateSubjectRow extends StatelessWidget {
  const CertificateSubjectRow({
    super.key,
    required this.subject,
    required this.maxScoreController,
    required this.scoreController,
  });

  final String subject;
  final TextEditingController maxScoreController;
  final TextEditingController scoreController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(bottom: 8),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: GradeBox(
              text: subject,
              alignment: Alignment.centerRight,
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: GradeInputBox(
              controller: maxScoreController,
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: GradeInputBox(
              controller: scoreController,
              isLight: true,
            ),
          ),
        ],
      ),
    );
  }
}