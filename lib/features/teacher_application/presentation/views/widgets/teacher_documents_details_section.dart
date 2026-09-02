import 'package:bnan_app/features/teacher_application/data/models/teacher_request_model.dart';
import 'package:bnan_app/features/teacher_application/presentation/views/widgets/teacher_document_link.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class TeacherDocumentsDetailsSection extends StatelessWidget {
  const TeacherDocumentsDetailsSection({super.key, required this.teacher});
  final TeacherRequestModel teacher;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(s.teacherDocuments),
        if (teacher.stableInternetProof.isNotEmpty)
          TeacherDocumentLink(
            label: s.stableInternetProof,
            url: teacher.stableInternetProof,
          ),
        for (
          var index = 0;
          index < teacher.experienceCertificates.length;
          index++
        )
          TeacherDocumentLink(
            label: '${s.experienceCertificates} ${index + 1}',
            url: teacher.experienceCertificates[index],
          ),
        const SizedBox(height: 12),
      ],
    );
  }
}
