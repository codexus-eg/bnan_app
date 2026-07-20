import 'package:bnan_app/features/teacher_application/data/models/details_field_data.dart';
import 'package:bnan_app/features/teacher_application/data/models/teacher_request_model.dart';
import 'package:bnan_app/features/teacher_application/presentation/views/widgets/details_section.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class PersonalDetailsSection extends StatelessWidget {
  const PersonalDetailsSection({super.key, required this.teacher});

  final TeacherRequestModel teacher;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return DetailsSection(
      title: s.teacherStepPersonalInfo,
      fields: [
        DetailsFieldData(s.city, teacher.city),
        DetailsFieldData(s.whatsappNumber, teacher.whatsapp),
        DetailsFieldData(s.country, teacher.country),
        DetailsFieldData(s.nationality, teacher.nationality),
      ],
    );
  }
}