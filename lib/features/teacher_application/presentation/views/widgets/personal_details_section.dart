import 'package:bnan_app/features/teacher_application/data/models/teacher_application_details_model.dart';
import 'package:bnan_app/features/teacher_application/presentation/views/widgets/details_section.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class PersonalDetailsSection extends StatelessWidget {
  const PersonalDetailsSection({super.key, required this.details});

  final TeacherApplicationDetailsModel details;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return DetailsSection(
      title: s.teacherStepPersonalInfo,
      fields: [
        DetailsFieldData(s.city, details.city),
        DetailsFieldData(s.birthDate, details.birthDate),
        DetailsFieldData(s.whatsappNumber, details.whatsapp),
        DetailsFieldData(s.country, details.country),
        DetailsFieldData(s.nationality, details.nationality),
      ],
    );
  }
}
