import 'package:bnan_app/features/teacher_application/data/models/details_field_data.dart';
import 'package:bnan_app/features/teacher_application/data/models/teacher_request_model.dart';
import 'package:bnan_app/features/teacher_application/presentation/views/widgets/details_section.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class QualificationDetailsSection extends StatelessWidget {
  const QualificationDetailsSection({super.key, required this.teacher});

  final TeacherRequestModel teacher;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return DetailsSection(
      title: s.teacherStepQualification,
      fields: [
        DetailsFieldData(s.graduationYear, teacher.graduationYear.toString()),
        DetailsFieldData(s.major, teacher.specialization),
        DetailsFieldData(s.universityOrInstitutionName, teacher.institutionName),
        DetailsFieldData(s.graduationGrade, teacher.graduationGrade),
        DetailsFieldData(s.qualification, teacher.degree),
      ],
    );
  }
}