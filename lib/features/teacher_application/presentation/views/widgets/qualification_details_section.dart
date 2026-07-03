import 'package:bnan_app/features/teacher_application/data/models/teacher_application_details_model.dart';
import 'package:bnan_app/features/teacher_application/presentation/views/widgets/details_section.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class QualificationDetailsSection extends StatelessWidget {
  const QualificationDetailsSection({super.key, required this.details});

  final TeacherApplicationDetailsModel details;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return DetailsSection(
      title: s.teacherStepQualification,
      fields: [
        DetailsFieldData(s.graduationYear, details.graduationYear),
        DetailsFieldData(s.major, details.major),
        DetailsFieldData(s.universityOrInstitutionName, details.university),
        DetailsFieldData(s.graduationGrade, details.graduationGrade),
        DetailsFieldData(s.qualification, details.qualification),
      ],
    );
  }
}
