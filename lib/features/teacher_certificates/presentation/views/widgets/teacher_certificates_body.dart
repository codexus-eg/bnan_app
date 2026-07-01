import 'package:bnan_app/core/shared_widget/add_new_topic_button.dart';
import 'package:bnan_app/core/utils/assets.dart';
import 'package:bnan_app/features/teacher_certificates/data/models/teacher_certificate_model.dart';
import 'package:bnan_app/features/teacher_certificates/presentation/views/dialogs/certificate_dialog.dart';
import 'package:bnan_app/features/teacher_certificates/presentation/views/widgets/certificate_card.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class TeacherCertificatesBody extends StatelessWidget {
  const TeacherCertificatesBody({super.key});

  static const certificates = [
    TeacherCertificateModel(
      imageUrl: 'assets/images/teacher_home/IMG-20260603-WA0030 2.png',
      totalScore: 99,
      maxScore: 100,
    ),
    TeacherCertificateModel(
      imageUrl: 'assets/images/teacher_home/IMG-20260603-WA0030 2.png',
      totalScore: 99,
      maxScore: 100,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.only(top: 16, end: 16),
          child: AddNewTopicButton(
            title: S.of(context).issueNewCertificate,
            onTap: () {
              showDialog(
                context: context,
                builder: (_) => const CertificateDialog(),
              );
            }, path: ImageManager.plus,
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsetsDirectional.all(16),
            itemCount: certificates.length,
            itemBuilder: (context, index) {
              return CertificateCard(certificate: certificates[index]);
            },
          ),
        ),
      ],
    );
  }
}
