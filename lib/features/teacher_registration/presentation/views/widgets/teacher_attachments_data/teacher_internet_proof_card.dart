import 'dart:io';
import 'package:bnan_app/features/teacher_registration/presentation/views/widgets/teacher_attachments_data/teacher_upload_file_card.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class TeacherInternetProofCard extends StatelessWidget {
  const TeacherInternetProofCard({
    super.key,
    required this.file,
    required this.onTap,
  });

  final File? file;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    if (file == null) {
      return TeacherUploadFileCard(
        title: S.of(context).stableInternetProof,
        file: null,
        onTap: onTap,
      );
    }
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.file(
              file!,
              height: 160,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 8),
          Text(S.of(context).replaceStableInternetProof),
        ],
      ),
    );
  }
}
