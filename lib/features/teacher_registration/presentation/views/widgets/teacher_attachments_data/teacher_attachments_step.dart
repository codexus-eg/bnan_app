import 'package:bnan_app/features/teacher_registration/presentation/views/widgets/teacher_attachments_data/teacher_declaration_section.dart';
import 'package:bnan_app/features/teacher_registration/presentation/views/widgets/teacher_attachments_data/teacher_upload_files_section.dart';
import 'package:flutter/material.dart';

class TeacherAttachmentsStep extends StatelessWidget {
  const TeacherAttachmentsStep({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        TeacherUploadFilesSection(),
        SizedBox(height: 16),
        TeacherDeclarationSection(),
      ],
    );
  }
}