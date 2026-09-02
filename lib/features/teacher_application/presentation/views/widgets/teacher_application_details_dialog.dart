import 'package:bnan_app/core/shared_widget/dialogs/custom_app_dialog.dart';
import 'package:bnan_app/features/teacher_application/data/models/teacher_request_model.dart';
import 'package:bnan_app/features/teacher_application/presentation/views/widgets/teacher_application_details_content.dart';
import 'package:bnan_app/features/teacher_application/presentation/views/widgets/teacher_application_details_header.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class TeacherApplicationDetailsDialog extends StatelessWidget {
  const TeacherApplicationDetailsDialog({
    super.key,
    required this.teacher,
  });

  final TeacherRequestModel teacher;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);

    return CustomAppDialog(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TeacherApplicationDetailsHeader(
              title: s.teacherApplicationDetailsTitle(
                teacher.user.fullName,
              ),
            ),
            const SizedBox(height: 16),
            Flexible(
              child: SingleChildScrollView(
                child: TeacherApplicationDetailsContent(
                  teacher: teacher,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
