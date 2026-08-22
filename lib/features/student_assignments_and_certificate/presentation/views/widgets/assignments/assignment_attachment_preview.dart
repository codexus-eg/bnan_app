import 'package:bnan_app/core/shared_widget/attachment_preview/network_attachment_preview.dart';
import 'package:bnan_app/features/student_assignments_and_certificate/data/models/student_assignment_model.dart';
import 'package:flutter/material.dart';

class AssignmentAttachmentPreview extends StatelessWidget {
  const AssignmentAttachmentPreview({super.key, required this.assignment});

  final AssignmentModel assignment;

  @override
  Widget build(BuildContext context) => NetworkAttachmentPreview(
    attachmentUrl: assignment.attachment,
    height: 140,
    borderRadius: BorderRadius.circular(8),
    title: assignment.title,
  );
}
