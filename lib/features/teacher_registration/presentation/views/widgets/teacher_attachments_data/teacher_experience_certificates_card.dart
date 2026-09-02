import 'dart:io';
import 'package:bnan_app/features/teacher_registration/presentation/views/widgets/teacher_attachments_data/teacher_upload_file_card.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class TeacherExperienceCertificatesCard extends StatelessWidget {
  const TeacherExperienceCertificatesCard({
    super.key,
    required this.files,
    required this.onTap,
  });

  final List<File> files;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TeacherUploadFileCard(
          title: S.of(context).experienceCertificatesOptional,
          file: null,
          onTap: onTap,
          isRequired: false,
        ),
        for (final file in files)
          ListTile(
            dense: true,
            leading: const Icon(Icons.insert_drive_file_outlined),
            title: Text(file.path.split(Platform.pathSeparator).last),
          ),
      ],
    );
  }
}
