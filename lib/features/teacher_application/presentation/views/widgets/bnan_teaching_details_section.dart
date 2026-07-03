import 'package:bnan_app/features/teacher_application/data/models/teacher_application_details_model.dart';
import 'package:bnan_app/features/teacher_application/presentation/views/widgets/details_section.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class BnanTeachingDetailsSection extends StatelessWidget {
  const BnanTeachingDetailsSection({super.key, required this.details});

  final TeacherApplicationDetailsModel details;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return DetailsSection(
      title: s.teachingInBnan,
      fields: [
        DetailsFieldData(s.weeklyHours, details.weeklyHours),
        DetailsFieldData(s.curriculum, details.curriculum),
        DetailsFieldData(s.desiredSubjects, details.desiredSubjects),
        DetailsFieldData(s.availability, details.availability),
        DetailsFieldData(s.teachableGrades, details.teachableGrades),
      ],
    );
  }
}
