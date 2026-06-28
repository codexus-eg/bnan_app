import 'package:bnan_app/features/parent_certificates/data/models/parent_certificate_model.dart';
import 'package:bnan_app/features/parent_certificates/presentation/views/widgets/parent_certificate_card.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class ParentCertificatesBody extends StatelessWidget {
  const ParentCertificatesBody({super.key});

  @override
  Widget build(BuildContext context) {
    final certificates = [
      ParentCertificateModel(
        image: 'assets/images/teacher_home/IMG-20260603-WA0030 2.png',
        title: 'شهادة تفوق في الرياضيات',
        studentName: 'ليلي خالد',
        grade: S.of(context).parentSecondPreparatoryGrade,
        teacherName: 'أ/ سارة عبدالله',
      ),
      ParentCertificateModel(
        image: 'assets/images/teacher_home/IMG-20260603-WA0030 2.png',
        title: 'شهادة تفوق في العلوم',
        studentName: 'ليلى خالد',
        grade: S.of(context).parentFirstPreparatoryGrade,
        teacherName: 'أ/ سارة عبدالله',
      ),
    ];

    return ListView.separated(
      padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 24),
      itemCount: certificates.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        return ParentCertificateCard(certificate: certificates[index]);
      },
    );
  }
}
