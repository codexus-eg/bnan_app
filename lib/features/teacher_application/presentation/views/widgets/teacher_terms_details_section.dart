import 'package:bnan_app/core/helper/app_pickers.dart';
import 'package:bnan_app/features/teacher_application/data/models/details_field_data.dart';
import 'package:bnan_app/features/teacher_application/data/models/teacher_request_model.dart';
import 'package:bnan_app/features/teacher_application/presentation/views/widgets/details_section.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class TeacherTermsDetailsSection extends StatelessWidget {
  const TeacherTermsDetailsSection({super.key, required this.teacher});
  final TeacherRequestModel teacher;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return DetailsSection(
      title: s.teacherTermsAndConditions,
      fields: [
        DetailsFieldData(s.termsAccepted, teacher.termsAccepted ? s.yes : s.no),
        DetailsFieldData(
          s.termsAcceptedAt,
          AppPickers.formatDateOnly(teacher.termsAcceptedAt),
        ),
        DetailsFieldData(s.termsVersion, teacher.termsVersion.toString()),
      ],
    );
  }
}
