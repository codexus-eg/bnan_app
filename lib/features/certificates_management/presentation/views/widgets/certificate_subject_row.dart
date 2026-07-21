import 'package:bnan_app/features/certificates_management/presentation/views/widgets/grade_box.dart';
import 'package:flutter/material.dart';

class CertificateSubjectRow extends StatelessWidget {
  const CertificateSubjectRow({super.key, required this.subject});

  final String subject;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(bottom: 8),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: GradeBox(text: subject, alignment: Alignment.centerRight),
          ),
          const SizedBox(width: 20),
          Expanded(flex: 1, child: const GradeBox(text: '20')),
          const SizedBox(width: 20),
          Expanded(flex: 1, child: const GradeBox(text: '19', isLight: true)),
        ],
      ),
    );
  }
}
