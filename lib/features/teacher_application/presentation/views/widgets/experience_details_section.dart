import 'package:bnan_app/features/teacher_application/data/models/teacher_application_details_model.dart';
import 'package:bnan_app/features/teacher_application/presentation/views/widgets/details_section.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class ExperienceDetailsSection extends StatelessWidget {
  const ExperienceDetailsSection({super.key, required this.details});

  final TeacherApplicationDetailsModel details;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return DetailsSection(
      title: s.teacherStepExperience,
      fields: [
        DetailsFieldData(
          s.taughtOnlineBefore,
          _yesNo(s, details.hasOnlineExperience),
        ),
        DetailsFieldData(s.gradeLevel, details.gradeLevel),
        DetailsFieldData(s.platformsUsed, details.platformsUsed),
        DetailsFieldData(
          s.hasTeachingExperience,
          _yesNo(s, details.hasExperience),
        ),
        DetailsFieldData(s.taughtSubjects, details.taughtSubjects),
      ],
    );
  }

  String _yesNo(S s, bool value) => value ? s.yes : s.no;
}
